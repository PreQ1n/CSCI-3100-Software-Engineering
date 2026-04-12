function refreshSlots(resourceId, date, resourceType) {
  if (!date) return;

  const url = resourceType === 'venue'
    ? `/venue_records/booked_slots?venue_id=${resourceId}&date=${date}`
    : `/equipment_records/booked_slots?equipment_id=${resourceId}&date=${date}`;

  fetch(url)
    .then(r => r.json())
    .then(bookedTimes => {
      document.querySelectorAll('.timeslot').forEach(cell => {
        const slot = cell.dataset.time;
        const isBooked = bookedTimes.includes(slot);

        cell.classList.remove('booked', 'available', 'selected');
        if (isBooked) {
          cell.classList.add('booked');
          cell.textContent = 'Booked';
        } else {
          cell.classList.add('available');
          cell.textContent = slot;
        }
      });
      // When date changes, clear selection
      document.getElementById('selected_time_value').value = '';
    });
}

const dateField = document.getElementById('booking_date');
const resourceType = dateField.dataset.resourceType;
const resourceId = dateField.dataset.venueId || dateField.dataset.equipmentId;

// When date changes, re-fetch
dateField.addEventListener('change', function () {
  refreshSlots(resourceId, this.value, resourceType);
});

// If date already has a value, on page load — refresh
// (covers edit form AND validation re-render)
if (dateField.value) {
  refreshSlots(resourceId, dateField.value, resourceType);
}

// Click to select an available slot
document.querySelectorAll('.timeslot').forEach(cell => {
  cell.addEventListener('click', function () {
    if (this.classList.contains('booked')) return;
    document.querySelectorAll('.timeslot').forEach(c => c.classList.remove('selected'));
    this.classList.add('selected');
    document.getElementById('selected_time_value').value = this.dataset.time;
  });
});

// Auto-refresh every 30 seconds to catch new bookings by other users
setInterval(() => {
  if (dateField.value) refreshSlots(resourceId, dateField.value, resourceType);
}, 30000);
