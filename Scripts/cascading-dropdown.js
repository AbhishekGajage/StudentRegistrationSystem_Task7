/* =========================================================
   Cascading Country -> State -> District dropdowns.
   Calls ASP.NET PageMethods (WebMethod, static, [ScriptMethod])
   defined in Register.aspx.cs:
     - GetStates(int countryId)
     - GetDistricts(int stateId)
   Requires ScriptManager EnablePageMethods="true" on the page.
   ========================================================= */

function initCascadingDropdowns(countryDropdownId, stateDropdownId, districtDropdownId) {
    var $country = $('#' + countryDropdownId);
    var $state = $('#' + stateDropdownId);
    var $district = $('#' + districtDropdownId);

    $country.on('change', function () {
        var countryId = $(this).val();
        resetDropdown($state, 'Select State');
        resetDropdown($district, 'Select District');

        if (!countryId) return;

        PageMethods.GetStates(parseInt(countryId, 10), function (result) {
            populateDropdown($state, result, 'Select State');
        }, onAjaxError);
    });

    $state.on('change', function () {
        var stateId = $(this).val();
        resetDropdown($district, 'Select District');

        if (!stateId) return;

        PageMethods.GetDistricts(parseInt(stateId, 10), function (result) {
            populateDropdown($district, result, 'Select District');
        }, onAjaxError);
    });
}

function populateDropdown($select, items, placeholder) {
    resetDropdown($select, placeholder);
    if (!items) return;

    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        // Guard against malformed rows (e.g. a NULL/blank name in the DB,
        // or a casing mismatch in the JSON) so we never render the
        // literal string "undefined" as an option.
        var id = item ? (item.Id !== undefined ? item.Id : item.id) : null;
        var name = item ? (item.Name !== undefined ? item.Name : item.name) : null;

        if (!name) continue; // skip rows with no usable label

        var opt = document.createElement('option');
        opt.value = id != null ? id : '';
        opt.text = name;
        $select.append(opt);
    }
    $select.prop('disabled', $select.find('option').length <= 1);
}

function resetDropdown($select, placeholder) {
    $select.empty();
    $select.append($('<option>', { value: '', text: placeholder }));
}

function onAjaxError(error) {
    console.error('Cascading dropdown error:', error.get_message());
    alert('Could not load location data. Please try again.');
}

/* =========================================================
   Mobile number validation via intl-tel-input (CDN, free/OSS)
   https://github.com/jackocnr/intl-tel-input
   ========================================================= */
var iti = null;

function initMobileValidation(inputId) {
    var input = document.querySelector('#' + inputId);
    if (!input || typeof window.intlTelInput === 'undefined') return;

    iti = window.intlTelInput(input, {
        initialCountry: 'in',
        preferredCountries: ['in', 'us', 'gb', 'au', 'ca'],
        utilsScript: 'Scripts/intlTelInput/js/utils.js'
    });

    input.addEventListener('blur', function () {
        validateMobileField(inputId);
    });
}

function validateMobileField(inputId) {
    var $errorEl = $('#' + inputId + '_error');
    if (!iti) return true;

    if ($.trim($('#' + inputId).val()) === '') {
        $errorEl.text('Mobile number is required.');
        return false;
    }
    if (!iti.isValidNumber()) {
        $errorEl.text('Please enter a valid mobile number for the selected country.');
        return false;
    }
    $errorEl.text('');
    return true;
}

/* Returns the full E.164 number, e.g. +919876543210, for form submission */
function getFullMobileNumber() {
    return iti ? iti.getNumber() : $('#txtMobile').val();
}