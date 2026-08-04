// Set current year in footer
document.getElementById("year").textContent = new Date().getFullYear();

// Button click: greet user (DOM: select element, change text content)
const greetBtn = document.getElementById("greetBtn");
const greetMsg = document.getElementById("greetMsg");

greetBtn.addEventListener("click", () => {
  greetMsg.textContent = "Thanks for stopping by! 👋";
});

fetch("/api/portfolio")
    .then(response => response.json())
    .then(data => {
        console.log(data);

        document.getElementById("name").textContent = data.profile.name;
        document.getElementById("tagline").textContent = data.profile.tagline;
        document.getElementById("about").textContent = data.profile.about;

        const skillsContainer = document.getElementById("skills");

        data.skills.forEach(skill => {
            const li = document.createElement("li");
            li.textContent = skill;
            skillsContainer.appendChild(li);
        });


        const projectsContainer = document.getElementById("projects");

        data.projects.forEach(project => {
            const div = document.createElement("div");

            div.innerHTML = `
                <h3>${project.title}</h3>
                <a href="${project.url}" target="_blank">
                    View Project
                </a>
            `;

            projectsContainer.appendChild(div);
        });

    })
    .catch(error => console.error(error));


const loginForm = document.getElementById("loginForm");


if(loginForm){

    loginForm.addEventListener("submit", function(e){

        e.preventDefault();


        const username =
        document.getElementById("username").value;


        const password =
        document.getElementById("password").value;


        // temporary login
        if(username === "admin" && password === "1234"){

            window.location.href = "admin.html";

        }else{

            document.getElementById("loginMessage")
            .textContent = "Invalid login";

        }

    });

}

 // Button click: add a new project to the list (DOM: create + append element)
// const addProjectBtn = document.getElementById("addProjectBtn");
// const projectList = document.getElementById("projectList");
// let projectCount = 1;

// addProjectBtn.addEventListener("click", () => {
//   const newItem = document.createElement("li");
//   newItem.textContent = `New Project ${projectCount}`;
//   projectList.appendChild(newItem);
//   projectCount++;
// });

// async function loadProfile() {

//     try {

//         const response = await fetch("/api/profile");

//         const profile = await response.json();

//         document.getElementById("name").textContent =
//             `Hi, I'm ${profile.name}`;

//         document.getElementById("tagline").textContent =
//             profile.tagline;

//         document.getElementById("aboutText").textContent =
//             profile.about;

//     } catch (error) {

//         console.error(error);

//     }

// }

// loadProfile();