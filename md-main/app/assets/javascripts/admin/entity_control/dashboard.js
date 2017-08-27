$(function(){
	var nowTemp = new Date();
	var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

	var checkout = $('#date_end').datepicker({
		format: 'dd-mm-yyyy'
	}).on('changeDate', function(ev) {
		checkout.hide();
	}).data('datepicker');
	var checkin = $('#date_start').datepicker({
		format: 'dd-mm-yyyy'
	}).on('changeDate', function(ev) {
		if (ev.valueOf() > checkout.valueOf()) {
			var newDate = new Date(ev.date)
			newDate.setDate(newDate.getDate() + 1);
			checkout.setValue(newDate);
		}
		checkin.hide();
		$('#date_end')[0].focus();
	}).data('datepicker');
});
