// #region Search

$(document).ready(function () {
    // Get the logo image elements
    var normalImage = $(".logo.normal-image");
    var hoverImage = $(".logo.hover-image");

    // Handle hover event
    normalImage.hover(
        function () {
            // On hover, hide the normal image and show the hover image
            normalImage.hide();
            hoverImage.show();
        },
        function () {
            // On hover out, hide the hover image and show the normal image
            normalImage.show();
            hoverImage.hide();
        }
    );
});


function toggleManaCheckbox(element) {
    if (element.classList.contains('form-control') || element.closest('.form-control')) {
        return;
    }

    const checkboxIcon = element.children[0];
    const selectElement = element.querySelector('.form-control');

    if (!selectElement) {
        return;
    }

    var selectId = selectElement.id;
    var newValue, oldValue;

    const selectedElement = document.getElementById(selectId);
    oldValue = selectedElement.value;

    if (checkboxIcon.classList.contains('undecided')) {
        checkboxIcon.classList.remove('undecided');
        checkboxIcon.classList.add('included');
        newValue = 1;
    } else if (checkboxIcon.classList.contains('included')) {
        checkboxIcon.classList.remove('included');
        checkboxIcon.classList.add('excluded');
        newValue = 2;
    } else if (checkboxIcon.classList.contains('excluded')) {
        checkboxIcon.classList.remove('excluded');
        checkboxIcon.classList.add('undecided');
        newValue = 0;
    }

    selectedElement.value = newValue;
    moveSelectedAttributeByValue(selectId, oldValue, newValue);
}

function moveSelectedAttributeByValue(selectId, sourceValue, targetValue) {
    const selectElement = document.getElementById(selectId);
    const options = Array.from(selectElement.options);

    for (var i = 0; i < options.length; i++) {
        if (options[i].value === sourceValue) {
            options[i].selected = false;
        }
        if (options[i].value === targetValue) {
            options[i].selected = true;
            options[i].setAttribute('selected', 'selected');
        }
    }
}

document.addEventListener('DOMContentLoaded', function () {
    var hasSearchPartial = document.getElementById('_SearchPartial') !== null;
    var hasSearchFull = document.getElementById('_SearchFull') !== null;

    if (hasSearchPartial || hasSearchFull) {
        document.addEventListener('click', function (event) {
            const element = event.target;

            if (element.classList.contains('mana-checkbox')) {
                toggleManaCheckbox(element);
            }
        });
    }
});

// #endregion

function initializeTooltips() {
    var elements = $('[data-toggle="tooltip"]');
    if (elements.length > 0) {
        elements.tooltip();
    }
}

$(document).ready(function () {
    initializeTooltips();
});

function submitModelToAction(controller, action, model) {
    var form = document.createElement("form");
    form.method = "post";
    form.action = "/" + controller + "/" + action; // Assuming the controller and action are in the same domain, adjust the URL as needed

    var input = document.createElement("input");
    input.type = "hidden";
    input.name = "json";
    input.value = model;

    form.appendChild(input);
    document.body.appendChild(form);
    form.submit();
}

document.addEventListener('DOMContentLoaded', function () {
    // Check if any <a> elements with class "submit-action-link" are present
    const links = document.querySelectorAll('a.submit-action-link');
    if (links.length === 0) {
        return; // No <a> elements with the class found, exit the function
    }

    // Add the click event listener to the <a> elements
    links.forEach(link => {
        link.addEventListener('click', function (event) {
            event.preventDefault(); // Prevent the default link behavior (e.g., navigating to a new page)

            // Get the controller, action, and model values from the <a> element's attributes or data attributes
            const controller = link.getAttribute('data-controller');
            const action = link.getAttribute('data-action');
            const model = link.getAttribute('data-model');

            // Call the submitModelToAction function with the extracted values
            submitModelToAction(controller, action, model);
        });
    });
});