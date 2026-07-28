// Set current year in footer
document.getElementById("year").textContent = new Date().getFullYear();

// Button click: greet user (DOM: select element, change text content)
const greetBtn = document.getElementById("greetBtn");
const greetMsg = document.getElementById("greetMsg");

greetBtn.addEventListener("click", () => {
  greetMsg.textContent = "Thanks for stopping by! 👋";
});

// Button click: add a new project to the list (DOM: create + append element)
const addProjectBtn = document.getElementById("addProjectBtn");
const projectList = document.getElementById("projectList");
let projectCount = 1;

addProjectBtn.addEventListener("click", () => {
  const newItem = document.createElement("li");
  newItem.textContent = `New Project ${projectCount}`;
  projectList.appendChild(newItem);
  projectCount++;
});