document.addEventListener('DOMContentLoaded', function() {
  setDisabled(true);
  addFormSubmitListener();
});

function setDisabled(disabled) {
  const fields = [
    'start_time', 'end_time', 'seminar_type_online', 'seminar_type_face_to_face'
  ];

  fields.forEach(function(fieldId) {
    const field = document.getElementById(fieldId);
    field.disabled = disabled;

    if (disabled) {
      field.classList.add('disabled');
    } else {
      field.classList.remove('disabled');
    }
  });
}

document.getElementById('monday_seminar').addEventListener('click', function() {
  setSchedule('22:00', '23:00');
  setSeminarFormat('online');
  setDisabledExcept(['seminar_type_online']);
});

document.getElementById('wednesday_seminar').addEventListener('click', function() {
  setSchedule('19:30', '21:30');
  setSeminarFormat(null);
  setDisabledExcept(['seminar_type_online', 'seminar_type_face_to_face']);
});

document.getElementById('saturday_seminar').addEventListener('click', function() {
  setSchedule('15:30', '18:30');
  setSeminarFormat(null);
  setDisabledExcept(['seminar_type_online', 'seminar_type_face_to_face']);
});

function setSchedule(startTime, endTime) {
  document.getElementById('start_time').value = startTime;
  document.getElementById('end_time').value = endTime;
}

function setSeminarFormat(type) {
  const online = document.getElementById('seminar_type_online');
  const faceToFace = document.getElementById('seminar_type_face_to_face');

  online.checked = (type === 'online');
  faceToFace.checked = (type === 'face_to_face');
}

function setDisabledExcept(exceptIds) {
  const fields = [
    'start_time', 'end_time', 'seminar_type_online', 'seminar_type_face_to_face'
  ];

  fields.forEach(function(fieldId) {
    const field = document.getElementById(fieldId);
    if (!exceptIds.includes(fieldId)) {
      field.disabled = true;
      field.classList.add('disabled');
    } else {
      field.disabled = false;
      field.classList.remove('disabled');
    }
  });
}

// フォーム送信イベントリスナーの追加
function addFormSubmitListener() {
  const form = document.querySelector('form'); // フォームの選択
  if (form) {
    form.addEventListener('submit', function() {
      // フォーム送信時に全フィールドを有効化
      setDisabled(false);
    });
  }
}