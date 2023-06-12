var slideIndex = 0;
showSlides(); // call showslide method

function showSlides() {
  var i;
  var slides = document.getElementsByClassName("image-sliderfade");
  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
  }

  slideIndex++;
  if (slideIndex > slides.length) {
    slideIndex = 1;
  }

  slides[slideIndex - 1].style.display = "block";
  setTimeout(showSlides, 4000);
}