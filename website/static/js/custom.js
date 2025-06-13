/**
 * Custom JavaScript para melhorar a experiência do usuário no site PDV Restaurant
 */

document.addEventListener('DOMContentLoaded', () => {
  // Inicializar os ícones Feather (se estiverem presentes)
  if (typeof feather !== 'undefined') {
    feather.replace();
  }

  // Adicionar efeitos de rolagem e animações
  addScrollAnimations();
  
  // Adicionar comportamento de navbar fixa com efeito de transparência
  setupNavbarBehavior();
  
  // Melhorar acessibilidade de código
  enhanceCodeBlocks();
  
  // Adicionar botão "Voltar ao topo"
  addBackToTopButton();
});

/**
 * Adiciona animações baseadas na rolagem da página
 */
function addScrollAnimations() {
  const animatedElements = document.querySelectorAll(
    '.animate-fade-in-up, .animate-fade-in-left, .animate-fade-in-right'
  );
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0) translateX(0)';
      }
    });
  }, { threshold: 0.1 });
  
  animatedElements.forEach(element => {
    element.style.opacity = '0';
    element.style.transition = 'opacity 0.8s ease-out, transform 0.8s ease-out';
    
    if (element.classList.contains('animate-fade-in-up')) {
      element.style.transform = 'translateY(30px)';
    } else if (element.classList.contains('animate-fade-in-left')) {
      element.style.transform = 'translateX(-30px)';
    } else if (element.classList.contains('animate-fade-in-right')) {
      element.style.transform = 'translateX(30px)';
    }
    
    observer.observe(element);
  });
}

/**
 * Configura o comportamento da navbar para ficar fixa e com efeito de transparência
 */
function setupNavbarBehavior() {
  const navbar = document.querySelector('.navbar');
  if (!navbar) return;
  
  let lastScrollPosition = 0;
  
  window.addEventListener('scroll', () => {
    const currentScrollPosition = window.scrollY;
    
    // Adiciona classe quando a página é rolada para baixo
    if (currentScrollPosition > 100) {
      navbar.classList.add('navbar-scrolled');
      
      // Esconder a navbar quando rola para baixo, mostrar quando rola para cima
      if (currentScrollPosition > lastScrollPosition && currentScrollPosition > 300) {
        navbar.style.transform = 'translateY(-100%)';
      } else {
        navbar.style.transform = 'translateY(0)';
      }
    } else {
      navbar.classList.remove('navbar-scrolled');
    }
    
    lastScrollPosition = currentScrollPosition;
  });
}

/**
 * Melhorar a experiência dos blocos de código
 */
function enhanceCodeBlocks() {
  const codeBlocks = document.querySelectorAll('pre code');
  
  codeBlocks.forEach(codeBlock => {
    // Adicionar botão para copiar código
    const copyButton = document.createElement('button');
    copyButton.className = 'code-copy-button';
    copyButton.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
    copyButton.title = 'Copiar código';
    
    const pre = codeBlock.parentNode;
    pre.style.position = 'relative';
    pre.appendChild(copyButton);
    
    copyButton.addEventListener('click', () => {
      const code = codeBlock.textContent;
      navigator.clipboard.writeText(code);
      
      copyButton.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
      copyButton.classList.add('copied');
      
      setTimeout(() => {
        copyButton.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
        copyButton.classList.remove('copied');
      }, 2000);
    });
    
    // Adicionar números de linha
    const lines = codeBlock.innerHTML.split('\n');
    if (lines.length > 3) {
      let lineNumbersWrapper = document.createElement('div');
      lineNumbersWrapper.className = 'code-line-numbers';
      
      for (let i = 0; i < lines.length; i++) {
        const lineNumber = document.createElement('span');
        lineNumber.textContent = i + 1;
        lineNumbersWrapper.appendChild(lineNumber);
      }
      
      pre.insertBefore(lineNumbersWrapper, codeBlock);
      pre.classList.add('has-line-numbers');
    }
  });
}

/**
 * Adiciona um botão "Voltar ao topo" que aparece após rolagem
 */
function addBackToTopButton() {
  const button = document.createElement('button');
  button.className = 'back-to-top-button';
  button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 15l-6-6-6 6"/></svg>';
  button.title = 'Voltar ao topo';
  document.body.appendChild(button);
  
  window.addEventListener('scroll', () => {
    if (window.scrollY > 300) {
      button.classList.add('show');
    } else {
      button.classList.remove('show');
    }
  });
  
  button.addEventListener('click', () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });
}
