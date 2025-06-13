import 'package:fluent_ui/fluent_ui.dart';
import '../../../core/constants/app_constants.dart';

/// Widget personalizado para toast pequeno e posicionado no topo centro
/// seguindo o design system do projeto
class CustomToast extends StatefulWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final Color? color;
  final Duration duration;
  final VoidCallback? onDismiss;

  const CustomToast({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.color,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppSizes.animationMedium,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Animar entrada
    _animationController.forward();

    // Auto-dismiss após duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted && widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.success;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 320,
                minHeight: 48,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.9),
                    color.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: GestureDetector(
                onTap: _dismiss,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícone
                      if (widget.icon != null) ...[
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                          child: Icon(
                            widget.icon!,
                            color: Colors.white,
                            size: AppSizes.iconSmall,
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                      ],

                      // Conteúdo
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título (opcional)
                            if (widget.title != null) ...[
                              Text(
                                widget.title!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],

                            // Mensagem
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.title != null ? 12 : 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Botão de fechar (pequeno)
                      const SizedBox(width: AppSizes.paddingSmall),
                      GestureDetector(
                        onTap: _dismiss,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                          child: Icon(
                            FluentIcons.chrome_close,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Função helper para mostrar o toast personalizado
void showCustomToast(
  BuildContext context, {
  required String message,
  String? title,
  IconData? icon,
  Color? color,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + AppSizes.paddingLarge,
      left: 0,
      right: 0,
      child: Center(
        child: CustomToast(
          message: message,
          title: title,
          icon: icon,
          color: color,
          duration: duration,
          onDismiss: () {
            overlayEntry.remove();
          },
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}
