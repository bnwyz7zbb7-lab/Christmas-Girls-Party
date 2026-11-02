CHRISTMAS GIRLS NIGHT — WEB APP MÓVIL

La aplicación es una página web adaptable a iPhone y Android. No requiere que las invitadas descarguen Supabase ni creen cuentas. Al abrir el enlace de la sala, todas pueden consultar y editar la misma organización.

ESTADO DE CONFIGURACIÓN
- Supabase project: christmas-girls-night
- Project ref: tghggdgiwbawxeyniwme
- Base de datos: creada y activa.
- Tabla cgn_rooms: creada con RLS activado y acceso directo revocado.
- RPC cgn_create_room / cgn_get_room / cgn_save_room: creadas y probadas.
- config.js: configurado con URL y publishable key pública.
- Sincronización: consulta cambios cada 4 segundos.

PUBLICACIÓN
Sube la carpeta completa christmas_girls_night a un host estático HTTPS, por ejemplo Netlify Drop (https://app.netlify.com/drop/). No elimines config.js, manifest.webmanifest, icon.svg ni sw.js. Cuando el host genere la URL pública, abre esa URL una vez: la aplicación creará una sala y agregará un parámetro ?room=UUID. Comparte la URL completa (incluido ?room=...) con tus amigas.

USO EN IPHONE / ANDROID
- iPhone: abre el enlace en Safari > Compartir > Añadir a pantalla de inicio.
- Android: abre el enlace en Chrome > menú ⋮ > Instalar aplicación o Añadir a pantalla de inicio.

SINCRONIZACIÓN
Los cambios se guardan en Supabase y los demás dispositivos consultan cambios cada 4 segundos. Todas deben usar exactamente el mismo enlace con ?room=... .

PRIVACIDAD
El enlace de la sala funciona como llave de acceso: cualquiera que lo tenga puede consultar y modificar los datos de esa cena. No lo publiques en redes ni incluyas información sensible. No hay cuentas de invitadas; el nombre que escriban es solo identificación dentro del grupo. Para cerrar la sala, elimina su registro de public.cgn_rooms desde Supabase.

CLAVES
config.js contiene únicamente la publishable key de Supabase, apta para el navegador. Nunca añadas service_role ni claves secretas al frontend.
