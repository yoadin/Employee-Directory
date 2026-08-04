fetch("/api/portfolio")

.then(response => response.json())

.then(data => {

    // ---------------- Profile ----------------

    document.getElementById("name").value =
    data.profile.name;

    document.getElementById("tagline").value =
    data.profile.tagline;

    document.getElementById("about").value =
    data.profile.about;

    const saveButton =
    document.getElementById("saveProfile");

    saveButton.addEventListener("click", () => {

        const updatedProfile = {

            name: document.getElementById("name").value,

            tagline: document.getElementById("tagline").value,

            about: document.getElementById("about").value

        };

        fetch("/api/profile", {

            method: "PUT",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify(updatedProfile)

        })

        .then(res => res.json())

        .then(() => {

            alert("Profile Updated!");

        });

    });


    // ---------------- Skills ----------------

    const skills =
    document.getElementById("skills");

    data.skills.forEach(skill => {

        let li = document.createElement("li");

        li.innerHTML = `
            ${skill}
            <button class="delete-skill">Delete</button>
        `;

        li.querySelector(".delete-skill")
        .addEventListener("click", () => {

            fetch(`/api/skills/${encodeURIComponent(skill)}`, {

                method: "DELETE"

            })

            .then(res => res.json())

            .then(() => {

                location.reload();

            });

        });

        skills.appendChild(li);

    });


    // ---------------- Projects ----------------

    const projects =
    document.getElementById("projects");

    data.projects.forEach(project => {

        let div = document.createElement("div");

        div.className = "project-card";

        div.innerHTML = `

            <h3>${project.title}</h3>

            <a href="${project.url || "#"}" target="_blank">
                View Project
            </a>

            <br><br>

            <button class="edit-project">
                Edit
            </button>

            <button class="delete-project">
                Delete
            </button>

        `;

        // Edit

        div.querySelector(".edit-project")
        .addEventListener("click", () => {

            let newTitle = prompt(
                "Edit project title:",
                project.title
            );

            if (!newTitle) return;

            let newUrl = prompt(
                "Edit project URL:",
                project.url || ""
            );

            fetch(`/api/projects/${project.id}`, {

                method: "PUT",

                headers: {
                    "Content-Type": "application/json"
                },

                body: JSON.stringify({

                    title: newTitle,

                    url: newUrl

                })

            })

            .then(res => res.json())

            .then(() => {

                alert("Project Updated!");

                location.reload();

            });

        });


        // Delete

        div.querySelector(".delete-project")
        .addEventListener("click", () => {

            if (!confirm("Delete this project?")) return;

            fetch(`/api/projects/${project.id}`, {

                method: "DELETE"

            })

            .then(res => res.json())

            .then(() => {

                location.reload();

            });

        });

        projects.appendChild(div);

    });


    // ---------------- Add Skill ----------------

    document.getElementById("addSkill")
    .addEventListener("click", () => {

        const skill =
        document.getElementById("newSkill").value.trim();

        if (!skill) return;

        fetch("/api/skills", {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                skill: skill
            })

        })

        .then(res => res.json())

        .then(() => {

            location.reload();

        });

    });


    // ---------------- Add Project ----------------

    document.getElementById("addProject")
    .addEventListener("click", () => {

        const title =
        document.getElementById("projectTitle").value.trim();

        const url =
        document.getElementById("projectUrl").value.trim();

        if (!title) return;

        fetch("/api/projects", {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({

                title: title,

                url: url

            })

        })

        .then(res => res.json())

        .then(() => {

            location.reload();

        });

    });

});