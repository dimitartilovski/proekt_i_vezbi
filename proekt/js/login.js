var loginURL =
  "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyAljKfXAlgb1mpR5gg7pezw3LPlpI_zGXg";

function login(event) {
  event.preventDefault();

  var form = event.target;

  var loginInfo = {
    email: form["email"].value,
    password: form["password"].value,
    returnSecureToken: true
  };

  fetch(loginURL, {
    method: "POST",
    body: JSON.stringify(loginInfo)
  })
    .then(function(response) {
      //   if (response.status != 200) {
      //     throw new Error("SERVER ERROR");
      //   }
      return response.json();
    })
    .then(function(data) {
      if (data.error) {
        document.getElementById("error").innerText = data.error.message;
        return;
      }

      localStorage.setItem("email", data.email);
      localStorage.setItem("token", data.idToken);

      window.location.href = "sales.html";
    })
    .catch(function(error) {
      console.log(error);
    });
}

// try {
//   throw new Error("Nekoj si error");
// } catch (error) {
//   alert("Ne mozis da smenis konstanta");
// }
