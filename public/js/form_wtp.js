
document.addEventListener("DOMContentLoaded", function () {
  const btn = document.getElementById("nuevoBotonWhatsapp");
  const modal = document.getElementById("nuevoModalWhatsapp");
  const close = modal.querySelector(".close");
  const form = document.getElementById("nuevoFormularioWhatsapp");

  btn.addEventListener("click", function (e) {
    e.preventDefault();
    modal.style.display = "block";
  });

  close.addEventListener("click", function () {
    modal.style.display = "none";
  });

  window.addEventListener("click", function (e) {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });

  form.addEventListener("submit", function (e) {
    e.preventDefault();

    const nombre = document.getElementById("nuevoNombre").value.trim();
    const email = document.getElementById("nuevoEmail").value.trim();
    const mensaje = document.getElementById("nuevoMensaje").value.trim();

    if (!nombre || !email || !mensaje) {
      alert("Por favor completa todos los campos.");
      return;
    }

    const telefono = "573001112233"; // Cambia por tu número real
    const texto = `Hola, soy ${nombre}. Mi correo es ${email}. ${mensaje}`;
    const url = `https://wa.me/${telefono}?text=${encodeURIComponent(texto)}`;

    window.open(url, "_blank");
    modal.style.display = "none";
    form.reset();
  });
});
