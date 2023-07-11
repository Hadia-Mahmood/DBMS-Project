var dropdown = document.getElementById("myDropdown");
var input = document.getElementById("selectedValueInput");

// Add event listener for when the dropdown value changes
dropdown.addEventListener("change", function() {
  // Get the selected value
  var selectedValue = dropdown.value;
  
  // Update the input field with the selected value
  input.value = selectedValue;
});





