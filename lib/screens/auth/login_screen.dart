import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme/app_colors.dart';
import '../../utils/validators.dart';
import '../../services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'admin@worktrack.pro');
  final _passCtrl = TextEditingController(text: 'admin123');
  bool _obscure = true, _remember = false, _isLoading = false;
  int _attempts = 0;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animCtrl.forward();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (ok) {
        NotificationService.success(context, 'Connexion réussie ! Redirection...', title: 'Bienvenue 👋');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
        });
      } else {
        _attempts++;
        final msg = _attempts >= 5 ? 'Compte bloqué 15 minutes' : 'Identifiants incorrects (${5 - _attempts} tentatives)';
        NotificationService.error(context, msg, title: 'Échec de connexion');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isSmall = w < 420;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 32, vertical: 24),
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(_animCtrl),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 72, height: 72, decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.sidebarColor, AppColors.primary]), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: AppColors.sidebarColor.withOpacity(0.3), blurRadius: 20)]), child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 38)),
                  const SizedBox(height: 16),
                  const Text('WorkTrack Pro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text('Gestion de Présence & RH', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 28),
                  Container(
                    padding: EdgeInsets.all(isSmall ? 20 : 28),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)]),
                    child: Form(
                      key: _formKey,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Email professionnel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, validator: AppValidators.email, decoration: _dec('exemple@worktrack.pro', Icons.email_outlined)),
                        const SizedBox(height: 18),
                        const Text('Mot de passe', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextFormField(controller: _passCtrl, obscureText: _obscure, validator: (v) => v?.isEmpty == true ? 'Requis' : null, onFieldSubmitted: (_) => _login(), decoration: _dec('••••••••', Icons.lock_outlined, suffix: IconButton(icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20), onPressed: () => setState(() => _obscure = !_obscure)))),
                        const SizedBox(height: 14),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          InkWell(onTap: () => setState(() => _remember = !_remember), child: Row(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 20, height: 20, child: Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), activeColor: AppColors.sidebarColor)), const SizedBox(width: 6), const Text('Se souvenir', style: TextStyle(fontSize: 13))])),
                          TextButton(onPressed: () => NotificationService.info(context, '📧 Lien envoyé à votre email'), child: const Text('Mot de passe oublié ?', style: TextStyle(fontSize: 13, color: AppColors.sidebarColor))),
                        ]),
                        const SizedBox(height: 20),
                        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.sidebarColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: _isLoading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)) : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Se connecter', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18)]),
                        )),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('© ${DateTime.now().year} WorkTrack Pro', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint, IconData icon, {Widget? suffix}) => InputDecoration(
    hintText: hint, prefixIcon: Icon(icon, size: 18),
    suffixIcon: suffix, filled: true, fillColor: AppColors.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.sidebarColor, width: 2)),
  );

  @override
  void dispose() {
    _animCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose();
    super.dispose();
  }
}
