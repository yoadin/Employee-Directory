const loginForm =
document.getElementById("loginForm");


loginForm.addEventListener("submit", e=>{

e.preventDefault();


const username =
document.getElementById("username").value;


const password =
document.getElementById("password").value;



if(username==="admin" && password==="1234"){

    localStorage.setItem("adminLoggedIn","true");

    window.location.href="admin.html";

}
else{

document.getElementById("loginMessage")
.textContent="Invalid login";

}


});