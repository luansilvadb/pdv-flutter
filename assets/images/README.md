# Assets de Imagens

Esta pasta contém as imagens locais do projeto.

## Estrutura recomendada:

```
assets/
  images/
    burgers/
      - burger1.jpg
      - burger2.jpg
      - etc...
    drinks/
      - drink1.jpg
      - drink2.jpg
      - etc...
    desserts/
      - dessert1.jpg
      - etc...
```

## Como usar no código:

```dart
// Para usar uma imagem local:
Image.asset('assets/images/burgers/burger1.jpg')

// Ou em um Product:
imageUrl: 'assets/images/burgers/burger1.jpg'
```

## Formatos suportados:
- .jpg / .jpeg
- .png
- .gif
- .webp
- .bmp
