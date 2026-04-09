# Technical Specification: Impressão de Cupons

## Overview
Integração com `GenerateReceiptPdf` e `PrintReceipt` da feature `printing` ao concluir um pedido.

## Components
1. **Domain**: `OrderEntity` servindo como input para `GenerateReceiptPdf`.
2. **UseCase**:
   - `GenerateReceiptPdf` cria o modelo PDF do pedido.
   - `PrintReceipt` aciona a interface nativa para enviar os bytes gerados.
3. **UI/Integration**: `PrintingListener` observando se há um pedido concluído ou botão manual na tela de sucesso.

## BDD Scenarios
**Scenario**: Sucesso ao imprimir
Given um `OrderEntity` concluído
When o usuário clica em "Imprimir Cupom"
Then `GenerateReceiptPdf` compila o PDF
And `PrintReceipt` envia o documento à fila da impressora OS
And mostra notificação de sucesso.