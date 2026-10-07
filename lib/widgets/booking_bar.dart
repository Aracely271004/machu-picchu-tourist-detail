import 'package:flutter/material.dart';

/// Barra inferior fija de la pantalla turística.
///
/// Presenta un precio referencial y un botón visual de reserva.
/// El botón no ejecuta lógica de negocio, de acuerdo con las
/// restricciones del proyecto.
class BookingBar extends StatelessWidget {
  const BookingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(30, 0, 0, 0),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Información del precio.
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desde',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                SizedBox(height: 2),
                Text(
                  'S/ 152',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                Text(
                  'por persona',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(width: 24),

            // Expanded permite que el botón ocupe
            // todo el espacio horizontal restante.
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  // Callback vacío:
                  // la sesión evalúa únicamente la interfaz.
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Reservar',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
