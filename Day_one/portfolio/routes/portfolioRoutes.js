const express = require("express");

const router = express.Router();


let projects = [
    {
        id:1,
        title:"Portfolio Website",
        url:"https://github.com/example"
    }
];



router.put("/projects/:id",(req,res)=>{

const id = Number(req.params.id);


const project = projects.find(
p=>p.id === id
);


if(!project){

return res.status(404).json({
message:"Project not found"
});

}


project.title = req.body.title;


res.json({
message:"Project updated",
project
});


});


module.exports = router;