const express = require("express");
const bodyParser =require("body-parser");
const path = require('path');
const ejs = require("ejs");
const bcrypt = require("bcrypt");
const saltRounds = 10;
const cookieParser = require("cookie-parser");
const router = express.Router();
const session = require('express-session');
require('dotenv').config()

const { createTokens , validateToken} = require("./JWT");



var connection =require('./database');
const app = express();


app.use(express.static("public"));


// for  templating  we will use ejs  and all ejs files will be in 
// view folder
app.set('view engine' , 'ejs');

// we will clean cache so that user can not go to restricted pages from back button 
app.use(function(req,res,next){

    res.set('Cache-Control','no-cache,private,must-revalidate,no-store');
    next();
    
 }); 



// we will use body parser to pass our request in the form of forms 
app.use(bodyParser.urlencoded({
    extended: true
}));



app.use(cookieParser());


app.use(session({
    secret: process.env.SECRETTWO,
    resave: false,
    saveUninitialized: true
  }));

// ////////////////////////////////ROUTES///////////////////////////////////////////////////////


// app.get("/",function(req,res){
//     // res.sendFile(staticPath+'/index.html');
//     // res.sendFile(path.join(__dirname,'public','index.html'));
//     // ##########
//     res.render('index');
//     // ###########
//  });

app.get("/aboutus",function(req,res){
    
    res.sendFile(path.join(__dirname,'public','aboutus.html'));
    
 });



// app.get("/availableflights",function(req,res){
//     // res.sendFile(staticPath+'/flights_available.html');
//     res.sendFile(path.join(__dirname,'public','flights_available.html'));
//  });


app.get("/register",function(req,res){
    // res.sendFile(staticPath+'/account.html');
    res.sendFile(path.join(__dirname,'public','account.html'));

 });

//  this page will only be available if user is authenticated ///
app.get("/adminpage", validateToken ,function(req,res){
    // res.sendFile(staticPath+'/admin.html');

    res.render('admin');
    // ********************************
 });



//  this page will only be available if user is authenticated ///
// app.get("/customerpage", validateToken ,function(req,res){
//     // res.sendFile(staticPath+'/customer.html');
//     res.render('customer');
//  }); 

//  this page will only be available if user is authenticated ///
app.get("/bookingpage", validateToken ,function(req,res){
    var id = req.query.id;
    var flightclass= req.query.flightclass
    console.log(id);
    console.log(flightclass);
    
   // Store the data in the session as an object
    req.session.data = {
    id: id,
    flightclass: flightclass
      };

    if (flightclass===undefined){
        var error= 'PLEASE SELECT CLASS ';
        res.render("message",{display:error});
    }
    else{
        res.sendFile(path.join(__dirname,'public','booking.html'));
 }
    
 }); 

 app.get("/SIGNIN_UP_FIRST",function(req,res){
    var error= 'SIGN IN OR SIGN UP FIRST  ';
    res.render("message",{display:error});
 });


// to go to  home search bar section 
app.get("/homepagesearchbar",function(req,res){
    res.redirect("/")
});

///////////////////////////////////////// admin sign in///////////////////////////////////////
app.post("/adminsignin",function(req,res){
    //getting data from frontend//
    var adminEmail=String(req.body.email);
    var adminPassword=String(req.body.password);
    console.log(adminEmail,adminPassword);

    //getting data from database
    var sql="select a.email, a.password from user_info a inner join user  b on  b.email=a.email where b.ID=(SELECT Admin_id FROM admin)";
    

    // checking database and frontend data
    connection.query(sql,function(error,result){
        if (error) {console.log(error);}
        else{
            //we are using result[0]because we know that our database 
            // has only 1 admin  and we know our query will return with only 1 result
            if (result[0].email === adminEmail && result[0].password === adminPassword){
                console.log (result);
                console.log('congragulations');
                //  creating cookie 
                const accessToken = createTokens(result[0]);
                // STORE THIS COOKIE IN USERS BROWSER 
                res.cookie("access-token", accessToken, {
                        // EXPIRATION OF THIS COOKIE IN MILI SECONDS = 1 DAY EXPIRATION TIME 
                         maxAge: 60 * 60 * 24 * 1 * 1000,
                        //  to secure cookies even more set http to true  that will not allow anyone to access it using dom from browser
                         httpOnly: true, 
                            });
              // change this to render to route////////////////////////////////
                res.redirect('/dashboard');
                
            }
            else{
                console.log('not a match');
                var error= ' wrong password email combination ';
                res.render("message",{display:error});
                
                
            };
        }
       
    });
});

////////////////////////////////////////// suggestions code//////////////////////////////////////////////////////////

//////////////////////////////// Define a route to handle GET requests for fetching data source////////////////////////////////////////
app.get('/get_data', (req, res) => {
    const searchQuery = req.query.search_query;
    const query = "SELECT DISTINCT source FROM flight WHERE source LIKE '%" + searchQuery + "%' LIMIT 10";

    connection.query(query, (error, results) => {
        if (error) {
            console.error('Error executing MySQL query: ' + error.stack);
            res.status(500).json([]);
            return;
        }
        res.json(results);
    });
});

app.get('/get_data2', function (req, res) {
    var search_query = req.query.search_query;
    var query = "SELECT DISTINCT destination FROM flight WHERE destination LIKE '%" + search_query + "%' LIMIT 10";

    connection.query(query, function (error, results, fields) {
        if (error) {
            console.log(error);
            res.status(500).send('Error occurred while fetching data.');
        } else {
            res.json(results);
        }
    });
});



// Execute the query for trending flights
app.get("/", function (req, res) {
    connection.query(
      `SELECT f.flight_id, f.destination, f.date, f.departure_time, c.price, c.discount,c.class
       FROM flight AS f
       JOIN class AS c ON f.flight_id = c.flight_id
       WHERE c.discount > 0 AND f.status='available' AND c.seats_left>0 ;`,
      (error, results) => {
        if (error) {
          console.error('Error executing query:', error);
          console.log(results);
          
          res.render("index", { flights: [] }); // Pass an empty array if an error occurs
          return;
        }
        console.log("result")
        console.log(results);
        res.render("index", { flights: results }); // Pass the results to the EJS template for rendering
      }
    );
  });


  app.get("/customerpage", function (req, res) {
    connection.query(
      `SELECT f.flight_id, f.destination, f.date, f.departure_time, c.price, c.discount,c.class
       FROM flight AS f
       JOIN class AS c ON f.flight_id = c.flight_id
       WHERE c.discount > 0 AND f.status='available' AND c.seats_left>0 ;`,
      (error, results) => {
        if (error) {
          console.error('Error executing query:', error);
          console.log(results);
          
          res.render("index", { flights: [] }); // Pass an empty array if an error occurs
          return;
        }
        console.log("result")
        console.log(results);
        res.render("customer", { flights: results }); // Pass the results to the EJS template for rendering
      }
    );
  });





//////////////////////////////////////// customer register///////////////////

app.post("/register",function(req,res){

    bcrypt.hash(req.body.password, saltRounds, function(err, hash) {
        //getting data from form//
    var Firstname=req.body.Firstname;
    var Lastname=req.body.Lastname;
    var email=req.body.email;
    var password=hash;

    var sql = "INSERT INTO user_info(email,password) VALUES('"+email+"','"+password+"'); INSERT INTO user(email) VALUES('"+email+"'); INSERT INTO  customer(customer_id,first_name,last_name) VALUES((SELECT ID FROM user WHERE email='"+email+"'),'"+Firstname+"','"+Lastname+"') ";

    // inserting form data into database //
    connection.query(sql,function(error,results, fields){
        if (error) {
            console.log(error);
            res.redirect('/register');
        }
        else{
            
            var msg= 'account created';
            res.render("message",{display:msg});
                
        }
       
    });
        
    });
    
});


/////////////////////////////////////////// CUSTOMER LOGIN ///////////////////////////////////////////////////
app.post("/customerLogin", function (req, res) {
    //getting data from form//
    var customerEmail = String(req.body.email);
    var customerPassword = String(req.body.password);
    console.log(customerEmail, customerPassword);

    //getting data from database
    var sql = "SELECT * FROM user_info WHERE email = '" + customerEmail + "' ";


    // checking database and frontend email
    connection.query(sql, function (error, result) {
        if (error) { console.log(error); }
        else {
            //    no email found
            if (result.length === 0) {
                console.log('not a match');
                res.send('error');
            }
            // email found
            else {
                //check password
                bcrypt.compare(customerPassword, result[0].password).then(isMatch => {
                    //   if  passwords not match
                    if (isMatch === false) {
                        console.log('not a match');
                        res.send('error');

                    }

                    // passwords match
                    else {

                        console.log(result);
                        //  creating cookie 
                        const accessToken = createTokens(result[0]);
                        // STORE THIS COOKIE IN USERS BROWSER 
                        res.cookie("access-token", accessToken, {
                            // EXPIRATION OF THIS COOKIE IN MILI SECONDS = 30 DAYS EXPIRATION TIME 
                            maxAge: 60 * 60 * 24 * 30 * 1000,
                            httpOnly: true,
                        });

                        // res.redirect('/customerpage');
                        res.send('success')
                    };
                })



            };
        }

    });
});



// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////// admin and customer  logout route  //////////////////////

app.post('/logout', (req, res) => {
  res.clearCookie('access-token');
  res.redirect('/'); // Redirect to the home page
});



// ADMIN DASHBOARD

app.get('/dashboard', (req, res) => {
    const adminQuery = 'SELECT Admin_id FROM admin';
    const customerQuery = 'SELECT COUNT(*) AS customerCount FROM customer';
    const customerFlightQuery = 'SELECT COUNT(*) AS customerFlightCount FROM customer_booked_flights';
  
    connection.query(adminQuery, (error1, results1) => {
      if (error1) {
        console.error(error1);
        return res.render('error');
      }
  
      const adminId = results1[0].Admin_id;
  
      connection.query(customerQuery, (error2, results2) => {
        if (error2) {
          console.error(error2);
          return res.render('error');
        }
  
        const customerCount = results2[0].customerCount;
  
        connection.query(customerFlightQuery, (error3, results3) => {
          if (error3) {
            console.error(error3);
            return res.render('error');
          }
  
          const customerFlightCount = results3[0].customerFlightCount;
  
          res.render("dashboard", { adminId: adminId, customerCount: customerCount, customerFlightCount: customerFlightCount });
        });
      });
    });
  });
  

// admin page :   creating new flights ////////////////////////////

app.post("/createFlight",function(req,res){
    //getting data from form//
    var flightID=req.body.flightID;
    var source=req.body.source;
    var Destination=req.body.Destination;
    var Date=req.body.Date;
    
    var AirplaneName=req.body.AirplaneName;
    var Terminal=req.body.Terminal;
    
    var Departure=req.body.Departure;
    var Arrival=req.body.Arrival;
    
    var BTotalSeats=req.body.BTotalSeats;
    var BPrice=req.body.BPrice;
    var BDiscount=req.body.BDiscount;


    var ETotalSeats=req.body.ETotalSeats;
    var EPrice=req.body.EPrice;
    var EDiscount=req.body.EDiscount;
    
    
    var sql = "INSERT INTO flight(flight_id,source,destination,date,departure_time,arrival_time,airplane_name,terminal,admin_id) VALUES('"+flightID+"',LOWER('"+source+"'),LOWER('"+Destination+"'), '"+Date+"','"+Departure+"','"+Arrival+"','"+AirplaneName+"','"+Terminal+"',(SELECT Admin_id FROM admin));INSERT INTO class VALUES('"+flightID+"','Business','"+BTotalSeats+"','"+BTotalSeats+"','"+BPrice+"','"+BDiscount+"'); INSERT INTO class VALUES('"+flightID+"','Economy','"+ETotalSeats+"','"+ETotalSeats+"','"+EPrice+"','"+EDiscount+"')";
    // inserting form data into database //
    connection.query(sql,function(error,results, fields){
        if (error) {
            console.log(error);
            var error= 'sorry please insert again';
            res.render("message",{display:error});
        }
        else{
                // var success='congrats new flight created';
                // res.render("message",{display:success});
                res.redirect('/admincrudoperations');
                 
                
        }
       
    });
        
    });



//  ADMIN PAGE : CRUD OPERATIONS 

//  see all flights
//  this page will be displayed after insertion 
app.get('/admincrudoperations',validateToken,function(req,res){
    var sql = "select f.flight_id,f.source,f.destination,f.date, f.departure_time, f.arrival_time,f.airplane_name,f.status,f.terminal,c.class,c.total_seats,c.seats_left,c.price,c.discount from flight f , class c where f.flight_id=c.flight_id";
    connection.query(sql,function(error,result){
        if (error) {
            console.log(error);
            var error= 'sorry please provide valid info ';
            res.render("message",{display:error});
        }
        else{
            res.render("flights",{flights:result});
            
                 
                
        }
       
    });
});

//  admin :delete flight
app.get('/delete-flight',validateToken,function(req,res){
    var id = req.query.id;
    var sql = "update flight set status='cancelled' where flight_id='"+id+"'; delete from class where flight_id='"+id+"'";
    
    connection.query(sql,function(error,result){
        if (error) {
            console.log(error);
            var error= 'sorry please try again';
            res.render("message",{display:error});
        }
        else{
            res.redirect('/admincrudoperations');
                 
                
        }
       
    });
}); 

// ################ admin : update flight
app.get('/updateflight',validateToken,function(req,res){
    var id = req.query.id;
    var sql="select f.flight_id,f.source,f.destination,f.date, f.departure_time, f.arrival_time,f.airplane_name,f.status,f.terminal,c.class,c.total_seats,c.seats_left,c.price,c.discount from flight f , class c where f.flight_id='"+id+"' AND c.flight_id='"+id+"'";
    
    
    
    connection.query(sql,function(error,result){
        if (error) {
            console.log(error);
            var error= 'sorry please try again';
            res.render("message",{display:error});
        }
        else{
            res.render("updateflight",{flights:result});
                 
                
        }
       
    });
}); 



app.post("/updateflight",function(req,res){
    //getting data from form//
    var flightID=req.body.flight_id;
    var Date=req.body.Date;
    var AirplaneName=req.body.AirplaneName; 
    var status=req.body.status;
    var Terminal=req.body.Terminal; 
    var Departure=req.body.Departure;
    var Arrival=req.body.Arrival;
    var BPrice=req.body.BPrice;
    var BDiscount=req.body.BDiscount;
    var EPrice=req.body.EPrice;
    var EDiscount=req.body.EDiscount;
    
    
    var sql="UPDATE flight set date=?,airplane_name=?, status=? , terminal=? ,departure_time=? , arrival_time=? where flight_id=? ";
    
    
    // inserting form data into database //
    connection.query(sql,[Date,AirplaneName,status,Terminal,Departure,Arrival,flightID],function(error){
        if (error) {
            console.log(error);
            var error= 'sorry please insert again';
            res.render("message",{display:error});
        }
        else{
            if (status === 'cancelled') {
                			        var deleteClassQuery="DELETE FROM class WHERE flight_id = ?";
                		     	    connection.query(deleteClassQuery, [flightID], function(error){
                			        	if (error) {
                           				  console.log(error);
                          				  var error= 'sorry please insert again';
                          			      res.render("message",{display:error});
                      					  }
                      			        else{
                					           res.redirect('/admincrudoperations')}
                                                   });
            }
            else {
                	var updateClass="UPDATE class set price=? ,discount=? where flight_id=? AND class='Business'; UPDATE class set price=? ,discount=? where flight_id=? AND class='Economy'";
                	connection.query(updateClass, [BPrice,BDiscount,flightID,EPrice,EDiscount,flightID], function(error){
                		        if (error) {
                                       	console.log(error);
                                      	var error= 'sorry please insert again';
                                			res.render("message",{display:error});
                      			                		  }
                      		    else{
                				    res.redirect('/admincrudoperations');}
                    }); }
        }
        
    });

    });



    // ********* ADMIN SEARCH FLIGHT

app.get("/flightsearch",validateToken,function(req,res){
        //getting data from form//
        var flightid=req.query.flightid;
        var source =req.query.source;
        var destination=req.query.destination;
        var flightclass=req.query.class;
        var airplaneName=req.query.airplaneName;
        var date=req.query.date;

        var sql= "select f.flight_id,f.source,f.destination,f.date,f.departure_time, f.arrival_time,f.airplane_name,f.status,f.terminal,c.class,c.total_seats,c.seats_left,c.price,c.discount from flight f INNER JOIN class c  ON f.flight_id = c.flight_id where f.flight_id LIKE'%"+flightid+"%' AND f.source LIKE'%"+source+"%'  AND f.destination LIKE'%"+destination+"%'  AND  c.class LIKE'%"+flightclass+"%' AND f.airplane_name LIKE'%"+airplaneName+"%'AND f.date LIKE'%"+date+"%'";
        
        connection.query(sql,function(error,result){
            if (error) {
                console.log(error);
                var error= 'sorry please search again';
                res.render("message",{display:error});
            }
            else{
                // res.render("searchFlight",{flights:result});
                res.render("flights",{flights:result});
            }
            
        });
            
        });
    // **************************** CUSTOMER SEARCH FLIGHTS****************************
    
app.get("/availableflights",function(req,res){
        //getting data from form//
        var departureDate=req.query.departureDate;
        var source =req.query.source;
        var destination=req.query.destination;


        


        var sql="select f.flight_id,f.source,f.destination,f.date,f.departure_time, f.arrival_time,c.class,c.seats_left,c.price,c.discount ,TIMEDIFF(f.arrival_time,f.departure_time) AS time_difference from  flight f INNER JOIN class c  ON f.flight_id = c.flight_id  WHERE f.source ='"+source+"' AND f.destination= '"+destination+"' AND (f.date BETWEEN '"+departureDate+"' AND DATE_ADD('"+departureDate+"', INTERVAL 30 DAY)) AND f.status='available'  AND c.class='Economy';select f.flight_id,f.source,f.destination,f.date,f.departure_time, f.arrival_time,c.class,c.seats_left,c.price,c.discount ,TIMEDIFF(f.arrival_time,f.departure_time) AS time_difference from  flight f INNER JOIN class c  ON f.flight_id = c.flight_id   WHERE f.source ='"+source+"' AND f.destination= '"+destination+"' AND (f.date BETWEEN '"+departureDate+"' AND DATE_ADD('"+departureDate+"', INTERVAL 30 DAY)) AND f.status='available' AND c.class='Business' ;";
        connection.query(sql,function(error,result){
            if (error) {
                console.log(error);
                var error= 'sorry please search again';
                res.render("message",{display:error});
            }
            else{

                console.log('result0');
                console.log(result[0]);
	         	console.log('result1');
                console.log(result[1]);
                console.log('actual result 1 endingggg');	
                
                res.render("flights_available",{flights:result});
                
            } 
        });
     });


    // *********************************************************************************

            

    app.get("/usersearch", validateToken, function (req, res) {
        var customerid = req.query.customerid;
        var firstname = req.query.firstname;
        var lastname = req.query.lastname;
        var email = req.query.email;
    
        var sql = `SELECT c.customer_id, c.first_name, c.last_name, u.email, t.flightID, t.ticket_id, t.class, t.passengerName, pcn.contact_number 
                   FROM customer c
                   INNER JOIN user u ON c.customer_id = u.ID
                   LEFT JOIN ticket t ON c.customer_id = t.customerID
                   LEFT JOIN passenger_contact_number pcn ON t.ticket_id = pcn.ticket_id
                   WHERE c.customer_id LIKE '%${customerid}%' 
                   AND c.first_name LIKE '%${firstname}%' 
                   AND c.last_name LIKE '%${lastname}%' 
                   AND u.email LIKE '%${email}%'`;
    
        connection.query(sql, function (error, result) {
            if (error) {
                console.log(error);
                var error = 'Sorry, there was an error. Please search again.';
                res.render("message", { display: error });
            } else {
                console.log(result);
                if (result.length === 0) {
                    // No users found
                    res.render("skymateusers", { users: [] });
                } else {
                    res.render("skymateusers", { users: result });
                }
            }
        });
    });

// booking process
app.post("/bookingProcess",function(req,res){
       
      
// Retrieve the data object from the session
    const data = req.session.data;

  // Access the individual data items
  const flightid = data.id;
  const fclass = data.flightclass;
  console.log('booking process info');
      console.log(flightid);
      console.log(fclass);
      res.redirect("/customerpage");

 });
// ***********************************
connection.connect(function(err){
    if(err)
         throw(err);
    console.log("connection successfull....");
});



app.listen(3000, function(){
    console.log("server started on port 3000")

});