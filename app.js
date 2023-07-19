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
const { verify } = require("crypto");
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


app.get('/update-flight-status', (req, res) => {
  const query = 'UPDATE flight SET status = ? WHERE date < CURDATE()';
  const values = ['departed'];

  connection.query(query, values, (error, results) => {
    if (error) throw error;
    console.log('Updated flight statuses to "departed"');
    res.send('Flight statuses updated');
  });
});


app.get("/register",function(req,res){
    // res.sendFile(staticPath+'/account.html');
    res.sendFile(path.join(__dirname,'public','account.html'));

 });
 
// Admin authentication middleware
const authenticateAdmin = (req, res, next) => {
    // Check if the user is an admin
    if (req.user.role !== "admin") {
      res.redirect("/SIGNIN_UP_FIRST");
      // return res.status(403).json({ error: "Access denied." });
    }
    next();
  };
  
  // Customer authentication middleware
  const authenticateCustomer = (req, res, next) => {
    // Check if the user is a customer
    if (req.user.role !== "customer") {
      res.redirect("/SIGNIN_UP_FIRST");
      // return res.status(403).json({ error: "Access denied." });
    }
    next();
  };

//  this page will only be available if user is authenticated ///
app.get("/adminpage", validateToken ,authenticateAdmin,function(req,res){
    // res.sendFile(staticPath+'/admin.html');

    res.render('admin');
    // ********************************
 });



//  this page will only be available if user is authenticated ///

// app.get("/customerpage2", validateToken,authenticateCustomer ,function(req,res){
//     // res.sendFile(staticPath+'/customer.html');
//     const  customerEmail=req.session.data2 
//     console.log('INSIDE CUSTOMER PAGE ROUTE');
//     console.log('the logged in user is');
//     console.log(customerEmail);

//     res.render('customer');
//  }); 


//  this page will only be available if user is authenticated ///
app.get("/bookingpage", validateToken,authenticateCustomer ,function(req,res){
    var id = req.query.id;
    var flightclass= req.query.flightclass
    var customerEmail= null;
    console.log(id);
    console.log(flightclass);
    
   // Store the data in the session as an object
    

    if (flightclass===undefined){
        var error= 'PLEASE SELECT CLASS ';
        res.render("message",{display:error});
    }
    else{
        req.session.data = {
            id: id,
            flightclass: flightclass,
            customerEmail:customerEmail
              };
        res.sendFile(path.join(__dirname,'public','booking.html'));
 }
    
 }); 

 app.get("/SIGNIN_UP_FIRST",function(req,res){
    var error= 'SIGN IN  FIRST  ';
    res.render("message",{display:error});
 });


// to go to  home search bar section 
app.get("/homepagesearchbar",function(req,res){
    res.redirect("/")
});

app.get("/custpagesearchbar",function(req,res){
    res.redirect("/customerpage")
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
// ***************************************************************************************************
                const accessToken = createTokens(result[0],'admin');
 // ***************************************************************************************************
                // STORE THIS COOKIE IN USERS BROWSER 
                res.cookie("access-token", accessToken, {
                        // EXPIRATION OF THIS COOKIE IN MILI SECONDS = 1 DAY EXPIRATION TIME 
                         maxAge: 60 * 60 * 24 * 1 * 1000,
                        //  to secure cookies even more set http to true  that will not allow anyone to access it using dom from browser
                         httpOnly: true, 
                            });
              
                // res.redirect('/dashboard');
                res.send('success')
                
            }
            else{
                console.log('not a match');
                var error= ' wrong password email combination ';
                // res.render("message",{display:error});
                // res.send('success')
                // console.log('not a match');
                res.send('error');
                
                
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
      `SELECT * FROM DISCOUNTED;`,
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

  
app.get("/customerpage", validateToken, authenticateCustomer, function (req, res) {
    // Get flights data from the `DISCOUNTED` table
    connection.query(`SELECT * FROM DISCOUNTED;`, (error, flightsResults) => {
        if (error) {
            console.error('Error executing flights query:', error);
            res.render("index", { flights: [] }); // Pass an empty array if an error occurs
            return;
        }

        // Assuming you have already set customerEmail in the session data
        const customerEmail = req.session.data2;
        console.log('INSIDE CUSTOMER PAGE ROUTE');
        console.log('the logged in user is');
        console.log(customerEmail);

        // Fetch additional data separately (replace the queries with your actual queries)
        connection.query(`SELECT * FROM user_flight_info WHERE email = ?;`, [customerEmail] , (error, otherDataResults) => {
            if (error) {
                console.error('Error executing user_flight_info query:', error);
                // You can handle the error or pass an empty array for otherDataResults if needed
                res.render("customer", { flights: flightsResults, otherData: [], userInfo: {} });
                return;
            }

            connection.query(`SELECT * FROM user_customer_info WHERE email = ?;`, [customerEmail], (error, userInfoResults) => {
                if (error) {
                    console.error('Error executing user_customer_info query:', error);
                    // You can handle the error or pass an empty object for userInfoResults if needed
                    res.render("customer", { flights: flightsResults, otherData: otherDataResults, userInfo: {} });
                    return;
                }

                // Assuming you have fetched the other data successfully, you can pass it to the template
                res.render("customer", { flights: flightsResults, otherData: otherDataResults, userInfo: userInfoResults });
            });
        });
    });
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
    
    
    
    var sql = "SELECT * FROM user_info WHERE email = '" + customerEmail + "'; ";


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
                        // ******************************************************************
                        const accessToken = createTokens(result[0], 'customer');
                        // ******************************************************************
                        // STORE THIS COOKIE IN USERS BROWSER 
                        res.cookie("access-token", accessToken, {
                            // EXPIRATION OF THIS COOKIE IN MILI SECONDS = 30 DAYS EXPIRATION TIME 
                            maxAge: 60 * 60 * 24 * 30 * 1000,
                            httpOnly: true,
                        });
                        
                        
                        // // at the time of log in we want to store the id of that user
                        // var sql2 = "Select ID from user where email='" + customerEmail + "'";
                        //  // inserting form data into database //
                        //  connection.query(sql2,function(error,results, fields){
                        //     if (error) {
                        //              console.log(error);
                        //               }
                        //      else{
                        //          // Store the user id in the session 
                        //          console.log(results);
                                   req.session.data2 = customerEmail; 
                        //          req.session.data2 = results[0]; 
                        //          console.log('session2 data');
                        //          console.log(req.session.data2);
                        //                  }});
                                
                                // res.redirect('/customerpage');
                                
                                //  
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

app.get('/dashboard',validateToken, authenticateAdmin,(req, res) => {
    const adminQuery = 'SELECT Admin_id FROM admin';
    const customerQuery = 'SELECT COUNT(*) AS customerCount FROM customer';
    const customerFlightQuery = 'SELECT COUNT(*) AS customerFlightCount FROM customer_booked_flights';
    const flightQuery = "SELECT COUNT(*) AS flightCount FROM flight WHERE status='available'";
  
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

          connection.query(flightQuery, (error4, results4) => {
            if (error4) {
              console.error(error4);
              return res.render('error');
            }
    
            const flightCount = results4[0].flightCount;
  
          res.render("dashboard", { adminId: adminId, customerCount: customerCount, customerFlightCount: customerFlightCount, flightcount: flightCount });
        });
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
app.get('/admincrudoperations',validateToken,authenticateAdmin,function(req,res){
    var sql = "select f.flight_id,f.source,f.destination,f.date, f.departure_time, f.arrival_time,f.airplane_name,f.status,f.terminal,c.class,c.total_seats,c.seats_left,c.price,c.discount from flight f , class c where f.flight_id=c.flight_id AND f.status='available'";
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
app.get('/delete-flight',validateToken,authenticateAdmin,function(req,res){
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
app.get('/updateflight',validateToken,authenticateAdmin,function(req,res){
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

app.get("/flightsearch",validateToken,authenticateAdmin,function(req,res){
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

            

    app.get('/usersearch', validateToken, authenticateAdmin, function (req, res) {
        var customerid = req.query.customerid;
        var firstname = req.query.firstname;
        var lastname = req.query.lastname;
        var email = req.query.email;
      
        var sql = `SELECT c.customer_id, c.first_name, c.last_name, u.email, t.flightID, t.ticket_id, t.class, t.passengerName, 
                           GROUP_CONCAT(pcn.contact_number SEPARATOR ' / ') AS contact_numbers
                   FROM customer c
                   INNER JOIN user u ON c.customer_id = u.ID
                   LEFT JOIN ticket t ON c.customer_id = t.customerID
                   LEFT JOIN passenger_contact_number pcn ON t.ticket_id = pcn.ticket_id
                   WHERE c.customer_id LIKE '%${customerid}%' 
                   AND c.first_name LIKE '%${firstname}%' 
                   AND c.last_name LIKE '%${lastname}%' 
                   AND u.email LIKE '%${email}%'
                   GROUP BY c.customer_id, c.first_name, c.last_name, u.email, t.flightID, t.ticket_id, t.class, t.passengerName`;
      
        connection.query(sql, function (error, result) {
          if (error) {
            console.log(error);
            var error = 'Sorry, there was an error. Please search again.';
            res.render('message', { display: error });
          } else {
            console.log(result);
      
            if (result.length === 0) {
              // No users found
              res.render('skymateusers', { users: [] });
            } else {
              res.render('skymateusers', { users: result });
            }
          }
        });
      });
      
// booking process
app.post("/bookingProcess",function(req,res){

    // Retrieve the data object from the session
    const data = req.session.data;
    const  customerEmail=req.session.data2 
    // Access the individual data items
    const flightid = data.id;
    const fclass = data.flightclass;
    
    console.log(" inside process method flightid");
    console.log(flightid);
    console.log(" inside process method flightclass");
    console.log(fclass);
    // getting Id of  logged in user  from session
    
    console.log("user logged in email  is");
    // const UserEmail=req.session.data2
    console.log(customerEmail);



    // GETTING FORM DATA
    var passengerName=req.body.passengerName;
    var formemail=req.body.email;
    var contact_number=req.body.contact_number;
    var second_contact_number=req.body.second_contact_number;
    var meal=req.body.meal;
    var card_number=req.body.card_number;
    var card_expiry_date=req.body.expiry_date;
    
   
          if(customerEmail===formemail){
                // IF YES INSERT DATA IN DATABASE
                // checking if user already has flight associated with him
                var DuplicateDataCheck="SELECT * from customer_booked_flights Where flightID='"+flightid+"' AND customer_ID =(select ID FROM user WHERE email='"+customerEmail+"')";
                 connection.query(DuplicateDataCheck,function(error,result){
                 if (error) {
                         console.log(error);
                          var error= 'PlEASE PROVIDE VALID INFO';
                          res.render("message",{display:error});
                             }
                            //  if user has no flight already booked
                 else if (result.length===0){
                             var sql="INSERT INTO customer_booked_flights VALUES('"+flightid+"',(select ID FROM user WHERE email='"+customerEmail+"')); INSERT INTO ticket(meal,PassengerName,customerID,flightID,class) VALUES('"+meal+"','"+passengerName+"',(select ID FROM user WHERE email='"+customerEmail+"'),'"+flightid+"','"+fclass+"'); INSERT INTO payment_card_info  (card_number,card_expiry_date) SELECT '"+card_number+"', '"+card_expiry_date+"' WHERE NOT EXISTS (SELECT 1 FROM payment_card_info p WHERE p.card_number = '"+card_number+"');SELECT * FROM class WHERE flight_id='"+flightid+"' AND class='"+fclass+"' ";
                            connection.query(sql,function(error,result){
                            if (error) {
                                         console.log(error);
                                         var error= 'PlEASE PROVIDE VALID CARD  INFO';
                                         res.render("message",{display:error});
                                      }
                            else{
                                        const ticketID=result[1].insertId;
                                        console.log("result 3 is");
                                        console.log(result[3]);
                                        const Wprice=result[3][0].price;
                                        console.log(Wprice);
                                        const Wdiscount=result[3][0].discount;
                                        console.log("discount");
                                        console.log(Wdiscount);
                                        const actualPrice= Wprice-((Wprice*Wdiscount)/100);
                                        console.log("actualPrice");
                                        console.log(actualPrice);
                                        var sqlTwo="INSERT INTO payment(ticket_id) VALUES('"+ticketID+"');INSERT INTO passenger_contact_number VALUES('"+ticketID+"','"+contact_number+"');INSERT INTO passenger_contact_number VALUES('"+ticketID+"','"+second_contact_number+"');INSERT INTO payment_details VALUES('"+ticketID+"','"+actualPrice+"','"+card_number+"');";
                                        connection.query(sqlTwo,function(error,result){
                                        if (error) {
                                                   console.log(error);
                                                   var error= 'PlEASE PROVIDE VALID  CARD INFO';
                                                   res.render("message",{display:error});
                                                    }
                                        else{
                                            var UpdateSeatsLeft= "UPDATE class SET seats_left= (seats_left)-1 WHERE flight_id='"+flightid+"'  AND class='"+fclass+"' ";
                                            connection.query(UpdateSeatsLeft,function(error,result){
                                                                                    if (error) {
                                                                                               console.log(error);
                                                                                               var error= 'Problem ';
                                                                                               res.render("message",{display:error});
                                                                                                }
                                                                                    else{
                                                                                               res.redirect("/customerpage");
                                                                                        } 
                                                                                    });  
                                            
                                            } 
                                        });              
                                } 
                            });

                         }
                //  if customer already has one ticket from that flight then
                else{
                    var sql="INSERT INTO ticket(meal,PassengerName,customerID,flightID,class) VALUES('"+meal+"','"+passengerName+"',(select ID FROM user WHERE email='"+customerEmail+"'),'"+flightid+"','"+fclass+"');INSERT INTO payment_card_info  (card_number,card_expiry_date) SELECT '"+card_number+"', '"+card_expiry_date+"' WHERE NOT EXISTS (SELECT 1 FROM payment_card_info p WHERE p.card_number = '"+card_number+"');SELECT * FROM class WHERE flight_id='"+flightid+"' AND class='"+fclass+"' ";
                            connection.query(sql,function(error,result){
                            if (error) {
                                         console.log(error);
                                         var error= 'PlEASE PROVIDE VALID  CARD INFO';
                                         res.render("message",{display:error});
                                      }
                            else{
                                        const ticketID=result[0].insertId;
                                        console.log("result 2 is");
                                        console.log(result[2]);
                                        const Wprice=result[2][0].price;
                                        console.log(Wprice);
                                        const Wdiscount=result[2][0].discount;
                                        console.log("discount");
                                        console.log(Wdiscount);
                                        const actualPrice= Wprice-((Wprice*Wdiscount)/100);
                                        console.log("actualPrice");
                                        console.log(actualPrice);
                                        var sqlTwo="INSERT INTO payment(ticket_id) VALUES('"+ticketID+"');INSERT INTO passenger_contact_number VALUES('"+ticketID+"','"+contact_number+"');INSERT INTO passenger_contact_number VALUES('"+ticketID+"','"+second_contact_number+"');INSERT INTO payment_details VALUES('"+ticketID+"','"+actualPrice+"','"+card_number+"');";
                                        connection.query(sqlTwo,function(error,result){
                                        if (error) {
                                                   console.log(error);
                                                   var error= 'PlEASE PROVIDE VALID  CARD INFO';
                                                   res.render("message",{display:error});
                                                    }
                                        else{
                                            var UpdateSeatsLeft= "UPDATE class SET seats_left= (seats_left)-1 WHERE flight_id='"+flightid+"'  AND class='"+fclass+"' ";
                                            connection.query(UpdateSeatsLeft,function(error,result){
                                                                                    if (error) {
                                                                                               console.log(error);
                                                                                               var error= 'Problem ';
                                                                                               res.render("message",{display:error});
                                                                                                }
                                                                                    else{
                                                                                               res.redirect("/customerpage");
                                                                                        } 
                                                                                    });  
                                            
                                            } 
                                        });              
                                } 
                            });

                    
                    }
                });

            //  ?############   // 
            }
            else{
                    var msg= 'Kindly Provide same  Email from which you have registered';
                    res.render("message",{display:msg});

                       }
   
});




app.delete("/deleteBooking/:ticketId", (req, res) => {
  const ticketId = req.params.ticketId;

  // Step 1: Fetch customerId from the ticket table
  connection.query("SELECT customerID, flightID, class FROM ticket WHERE ticket_id = ?", [ticketId], (error, ticketResult) => {
    if (error) {
      console.error("Error fetching customerId:", error);
      return res.status(500).json({ error: "Failed to fetch customer ID" });
    }

    if (ticketResult.length === 0) {
      console.error("No matching ticket found");
      return res.status(404).json({ error: "Ticket not found" });
    }

    const customerId = ticketResult[0].customerID;

    // Step 2: Fetch cardNumber from the payment_details table
    connection.query("SELECT card_number FROM payment_details WHERE ticketID = ?", [ticketId], (error, paymentResult) => {
      if (error) {
        console.error("Error fetching cardNumber:", error);
        return res.status(500).json({ error: "Failed to fetch card number" });
      }

      if (paymentResult.length === 0) {
        console.error("No matching payment details found");
        return res.status(404).json({ error: "Payment details not found" });
      }

      const cardNumber = paymentResult[0].card_number;

      // Step 5: Delete the record from the payment_details table using ticketId
      connection.query("DELETE FROM payment_details WHERE ticketID = ?", [ticketId], (error, result) => {
        if (error) {
          console.error("Error deleting payment_details:", error);
          return res.status(500).json({ error: "Failed to delete payment details" });
        }

        // Step 6: Delete the record from the passenger_contact_number table using ticketId
        connection.query("DELETE FROM passenger_contact_number WHERE ticket_id = ?", [ticketId], (error, result) => {
          if (error) {
            console.error("Error deleting passenger_contact_number:", error);
            return res.status(500).json({ error: "Failed to delete passenger contact number" });
          }

          // Step 7: Delete the record from the ticket table (last step since it has foreign key constraints)
          connection.query("DELETE FROM ticket WHERE ticket_id = ?", [ticketId], (error, result) => {
            if (error) {
              console.error("Error deleting ticket:", error);
              return res.status(500).json({ error: "Failed to delete ticket" });
            }

            // Step 8: Increment seats_left in the class table
            connection.query(
              "UPDATE class SET seats_left = seats_left + 1 WHERE flight_id = ? AND class = ?",
              [ticketResult[0].flightID, ticketResult[0].class],
              (error, result) => {
                if (error) {
                  console.error("Error updating seats_left in class table:", error);
                  return res.status(500).json({ error: "Failed to update seats_left in class table" });
                }

                // Step 3: Delete the record from the customer_booked_flights table using customerId
                connection.query("DELETE FROM customer_booked_flights WHERE (customer_ID, flightID) NOT IN (SELECT customerID, flightID FROM ticket);", (error, result) => {
                  if (error) {
                    console.error("Error deleting customer_booked_flights:", error);
                    return res.status(500).json({ error: "Failed to delete customer booked flights" });
                  }

                  // Step 4: Delete the record from the payment_card_info table using cardNumber only when no other ticket has the same card number
                  connection.query("SET SQL_SAFE_UPDATES = 0;DELETE FROM payment_card_info WHERE card_number NOT IN (SELECT card_number FROM payment_details);", (error, result) => {
                    if (error) {
                      console.error("Error deleting payment_card_info:", error);
                      return res.status(500).json({ error: "Failed to delete payment card info" });
                    }

                    // All deletions and updates were successful
                    return res.status(200).json({ message: "Booking canceled successfully" });
                  });
                });
              }
            );
          });
        });
      });
    });
  });
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
