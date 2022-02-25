/* created a collection Academy , and inserted one course with additional details. */
db.Academy.insertOne(
{
    coursename :  "Data Structures and Algorithms",
    Instructor :  "Proff. Mukesh jadon",
    Lectures : 40,
    Students : [{name : "Naveen Jain" , Rno : 159}]
} 
)
/* enrolled a student in the specific course*/

db.Academy.update(
{ _id : ObjectId("621870a08c6deb29e1c2c899") },
{
    $push :
    {
        Students : {name : "Rahul Khandelwal" , Rno : 108}
    }
}
)
/* Launched a new course in the academy */
db.Academy.insertOne(
{
    coursename : "Computer Networks",
    Instructor : "Proff. Subrat Dash"
}
)
/* Enrollment of Students */

db.Academy.update(
{ _id : ObjectId("621871e78c6deb29e1c2c89a")},
{
    $push :
    {
        Students : {name : "Kartik Singh" , Rno : 181}
    }
}
)

db.Academy.update(
{
   coursename : "Computer Networks"
},
{
    $push : 
    {
        Students:{name : "Naveen Jain" , Rno : 159 , type : "exchange"}
    }
}
)

/* deleted the entry of the student */
db.Academy.update(
{
   coursename : "Computer Networks"
},
{
    $pull : 
    {
        Students:{name : "Naveen Jain" , Rno : 159 , type : "exchange"}
    }
}
)

/* updated the information about the specific course */

db.Academy.update(
{
   _id : ObjectId("621871e78c6deb29e1c2c89a")
} , 
{
   $set:{
       coursetype : "Optional"
   }
}
)










