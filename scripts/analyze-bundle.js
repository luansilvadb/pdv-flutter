#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

/**
 * Script para análise detalhada do bundle Flutter Web
 * Analisa tamanhos de arquivos e identifica oportunidades de otimização
 */

const BUILD_DIR = path.join(process.cwd(), 'build', 'web');
const ASSETS_DIR = path.join(BUILD_DIR, 'assets');

function formatBytes(bytes) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function getFileSize(filePath) {
  try {
    return fs.statSync(filePath).size;
  } catch (error) {
    return 0;
  }
}

function analyzeDirectory(dirPath, basePath = '') {
  const files = [];
  
  try {
    const items = fs.readdirSync(dirPath);
    
    for (const item of items) {
      const itemPath = path.join(dirPath, item);
      const relativePath = path.join(basePath, item);
      const stats = fs.statSync(itemPath);
      
      if (stats.isDirectory()) {
        files.push(...analyzeDirectory(itemPath, relativePath));
      } else {
        files.push({
          path: relativePath,
          fullPath: itemPath,
          size: stats.size,
          extension: path.extname(item).toLowerCase()
        });
      }
    }
  } catch (error) {
    console.warn(`Erro ao analisar diretório ${dirPath}:`, error.message);
  }
  
  return files;
}

function analyzeBuild() {
  console.log('🔍 Analisando Bundle Flutter Web...\n');
  
  if (!fs.existsSync(BUILD_DIR)) {
    console.error('❌ Diretório build/web não encontrado. Execute flutter build web primeiro.');
    process.exit(1);
  }
  
  const allFiles = analyzeDirectory(BUILD_DIR);
  const totalSize = allFiles.reduce((sum, file) => sum + file.size, 0);
  
  console.log(`📊 Análise Completa do Bundle`);
  console.log(`Total de arquivos: ${allFiles.length}`);
  console.log(`Tamanho total: ${formatBytes(totalSize)}\n`);
  
  // Agrupar por extensão
  const byExtension = {};
  allFiles.forEach(file => {
    const ext = file.extension || 'sem extensão';
    if (!byExtension[ext]) {
      byExtension[ext] = { count: 0, size: 0, files: [] };
    }
    byExtension[ext].count++;
    byExtension[ext].size += file.size;
    byExtension[ext].files.push(file);
  });
  
  console.log('📁 Análise por Tipo de Arquivo:');
  Object.entries(byExtension)
    .sort(([,a], [,b]) => b.size - a.size)
    .forEach(([ext, data]) => {
      const percentage = ((data.size / totalSize) * 100).toFixed(1);
      console.log(`  ${ext.padEnd(12)} ${data.count.toString().padStart(3)} arquivos  ${formatBytes(data.size).padStart(10)}  (${percentage}%)`);
    });
  
  console.log('\n🎯 Maiores Arquivos:');
  allFiles
    .sort((a, b) => b.size - a.size)
    .slice(0, 20)
    .forEach((file, index) => {
      const percentage = ((file.size / totalSize) * 100).toFixed(1);
      console.log(`  ${(index + 1).toString().padStart(2)}. ${file.path.padEnd(40)} ${formatBytes(file.size).padStart(10)}  (${percentage}%)`);
    });
  
  // Análise específica Flutter
  console.log('\n🎨 Análise Específica Flutter:');
  
  const dartFiles = allFiles.filter(f => f.path.includes('main.dart') || f.path.includes('.js'));
  const flutterAssets = allFiles.filter(f => f.path.startsWith('assets/'));
  const canvaskitFiles = allFiles.filter(f => f.path.includes('canvaskit'));
  const fontFiles = allFiles.filter(f => ['.woff', '.woff2', '.ttf', '.otf'].includes(f.extension));
  const imageFiles = allFiles.filter(f => ['.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp'].includes(f.extension));
  
  console.log(`  Dart/JS principal: ${formatBytes(dartFiles.reduce((sum, f) => sum + f.size, 0))}`);
  console.log(`  Assets Flutter: ${formatBytes(flutterAssets.reduce((sum, f) => sum + f.size, 0))}`);
  console.log(`  CanvasKit: ${formatBytes(canvaskitFiles.reduce((sum, f) => sum + f.size, 0))}`);
  console.log(`  Fontes: ${formatBytes(fontFiles.reduce((sum, f) => sum + f.size, 0))}`);
  console.log(`  Imagens: ${formatBytes(imageFiles.reduce((sum, f) => sum + f.size, 0))}`);
  
  // Recomendações
  console.log('\n💡 Recomendações de Otimização:');
  
  if (imageFiles.length > 0) {
    const largeImages = imageFiles.filter(f => f.size > 100 * 1024); // > 100KB
    if (largeImages.length > 0) {
      console.log(`  ⚠️  ${largeImages.length} imagens grandes encontradas (>100KB)`);
      console.log('     Considere otimizar com WebP ou redimensionar');
    }
  }
  
  const jsFiles = allFiles.filter(f => f.extension === '.js');
  const largeJsFiles = jsFiles.filter(f => f.size > 500 * 1024); // > 500KB
  if (largeJsFiles.length > 0) {
    console.log(`  ⚠️  ${largeJsFiles.length} arquivos JS grandes encontrados (>500KB)`);
    console.log('     Verifique se tree-shaking está funcionando corretamente');
  }
  
  if (fontFiles.length > 10) {
    console.log(`  ⚠️  ${fontFiles.length} arquivos de fonte encontrados`);
    console.log('     Considere usar apenas fontes necessárias');
  }
  
  if (totalSize > 10 * 1024 * 1024) { // > 10MB
    console.log('  ⚠️  Bundle muito grande (>10MB)');
    console.log('     Considere implementar lazy loading ou code splitting');
  }
  
  console.log('\n✅ Análise concluída!');
  
  // Salvar relatório em JSON
  const report = {
    timestamp: new Date().toISOString(),
    summary: {
      totalFiles: allFiles.length,
      totalSize: totalSize,
      totalSizeFormatted: formatBytes(totalSize)
    },
    byExtension,
    largestFiles: allFiles.sort((a, b) => b.size - a.size).slice(0, 20),
    recommendations: {
      hasLargeImages: imageFiles.some(f => f.size > 100 * 1024),
      hasLargeJsFiles: jsFiles.some(f => f.size > 500 * 1024),
      hasManyFonts: fontFiles.length > 10,
      isBundleTooLarge: totalSize > 10 * 1024 * 1024
    }
  };
  
  fs.writeFileSync(
    path.join(BUILD_DIR, 'bundle-analysis.json'),
    JSON.stringify(report, null, 2)
  );
  
  console.log(`📄 Relatório detalhado salvo em: build/web/bundle-analysis.json`);
}

if (require.main === module) {
  analyzeBuild();
}

module.exports = { analyzeBuild, formatBytes };