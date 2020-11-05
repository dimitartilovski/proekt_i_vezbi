var registerURL =
  "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAljKfXAlgb1mpR5gg7pezw3LPlpI_zGXg";

function register(event) {
  event.preventDefault();

  var form = event.target;

  if (form.password.value != form.password2.value) {
    alert("Password do not match!");
    return;
  }

  var registerInfo = {
    email: form.email.value,
    password: form.password.value,
    returnSecureToken: true
  };

  fetch(registerURL, {
    method: "POST",
    body: JSON.stringify(registerInfo)
  })
    .then(function(response) {
      return response.json();
    })
    .then(function(data) {
      console.log(data);
      window.location.href = "login.html";
    });
}
