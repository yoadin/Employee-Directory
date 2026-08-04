const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = 3000;

// Middleware
app.use(express.json());
app.use(express.static("public"));

// Portfolio file path
const filePath = path.join(__dirname, "data", "portfolio.json");

// Read portfolio
function getPortfolio() {
    const data = fs.readFileSync(filePath, "utf-8");
    return JSON.parse(data);
}

// Save portfolio
function savePortfolio(portfolio) {
    fs.writeFileSync(
        filePath,
        JSON.stringify(portfolio, null, 2)
    );
}

//
// ====================== GET PORTFOLIO ======================
//

app.get("/api/portfolio", (req, res) => {

    const portfolio = getPortfolio();

    res.json(portfolio);

});

//
// ====================== UPDATE PROFILE ======================
//

app.put("/api/profile", (req, res) => {

    const portfolio = getPortfolio();

    portfolio.profile = req.body;

    savePortfolio(portfolio);

    res.json({
        message: "Profile updated successfully"
    });

});

//
// ====================== ADD SKILL ======================
//

app.post("/api/skills", (req, res) => {

    const portfolio = getPortfolio();

    const newSkill = req.body.skill;

    if (!newSkill) {
        return res.status(400).json({
            message: "Skill is required"
        });
    }

    portfolio.skills.push(newSkill);

    savePortfolio(portfolio);

    res.json({
        message: "Skill added successfully"
    });

});

//
// ====================== DELETE SKILL ======================
//

app.delete("/api/skills/:skill", (req, res) => {

    const portfolio = getPortfolio();

    const skill = decodeURIComponent(req.params.skill);

    portfolio.skills = portfolio.skills.filter(
        s => s !== skill
    );

    savePortfolio(portfolio);

    res.json({
        message: "Skill deleted successfully"
    });

});

//
// ====================== ADD PROJECT ======================
//

app.post("/api/projects", (req, res) => {

    const portfolio = getPortfolio();

    const newProject = {

        id: portfolio.projects.length > 0
            ? Math.max(...portfolio.projects.map(project => project.id)) + 1
            : 1,

        title: req.body.title,

        url: req.body.url || ""

    };

    portfolio.projects.push(newProject);

    savePortfolio(portfolio);

    res.json({
        message: "Project added successfully",
        project: newProject
    });

});

//
// ====================== UPDATE PROJECT ======================
//

app.put("/api/projects/:id", (req, res) => {

    const portfolio = getPortfolio();

    const projectId = Number(req.params.id);

    const project = portfolio.projects.find(
        project => project.id === projectId
    );

    if (!project) {
        return res.status(404).json({
            message: "Project not found"
        });
    }

    project.title = req.body.title;
    project.url = req.body.url;

    savePortfolio(portfolio);

    res.json({
        message: "Project updated successfully",
        project
    });

});

//
// ====================== DELETE PROJECT ======================
//

app.delete("/api/projects/:id", (req, res) => {

    const portfolio = getPortfolio();

    const projectId = Number(req.params.id);

    portfolio.projects = portfolio.projects.filter(
        project => project.id !== projectId
    );

    savePortfolio(portfolio);

    res.json({
        message: "Project deleted successfully"
    });

});

//
// ====================== START SERVER ======================
//

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});