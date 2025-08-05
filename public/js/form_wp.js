document.addEventListener("DOMContentLoaded", function () {
  const openBtn = document.getElementById("openWhatsappForm");
  const modal = document.getElementById("whatsappFormModal");
  const closeBtn = modal.querySelector(".close");
  const form = document.getElementById("whatsappForm");

  openBtn.addEventListener("click", function (e) {
    e.preventDefault();
    modal.style.display = "block";
  });

  closeBtn.addEventListener("click", function () {
    modal.style.display = "none";
  });

  window.addEventListener("click", function (e) {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });

  form.addEventListener("submit", function (e) {
    e.preventDefault();
    const nombre = document.getElementById("nombre").value;
    const mensaje = document.getElementById("mensaje").value;

    const telefono = "573001112233"; // tu número de WhatsApp
    const texto = `Hola, mi nombre es ${nombre}. ${mensaje}`;
    const url = `https://wa.me/${telefono}?text=${encodeURIComponent(texto)}`;

    window.open(url, "_blank");
    modal.style.display = "none";
    form.reset();
  });
});
