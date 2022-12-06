({
    unrender: function (component, event) {
        this.superUnrender();
        var fieldsToClear = component.find('intakeRequestFormAdoptionImpact');
        if (fieldsToClear) {            
            if ($A.util.isArray(fieldsToClear)) {
                for (var i = 0; i < fieldsToClear.length; i++) {
                    fieldsToClear[i].set('v.value', null);
                }
            }
            else {
				fieldsToClear.set('v.value', null);
            }
        }
    }
})