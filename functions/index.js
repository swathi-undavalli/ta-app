const functions = require('firebase-functions');
const momenttz = require('moment-timezone');
const moment = require('moment');
<<<<<<< HEAD
const admin = require("firebase-admin");
=======
const admin = require('firebase-admin');
>>>>>>> kamesh/attendance

const accountSid = "ACb839390b5db07ab831317c8fde96b2e1";
const authToken = "c55be15ad66ceda34be06d8d672ab881";
const client = require('twilio')(accountSid, authToken);
const twilioNumber = '+13347814191' // your twilio phone number


admin.initializeApp();

const db = admin.firestore();

exports.addAttendanceLog = functions.https.onRequest(async (req, res) => {
    try {
        //const { sender, group, groupId, users } = req.body;
        //res.send(req.body)

            var logTimeJS=new Date(req.body.RealTime.PunchLog.LogTime);
<<<<<<< HEAD
            console.log(logTimeJS)
            var logTime=moment(logTimeJS);
             console.log(logTime)

            logTime.tz("Asia/Kolkata").format();

             console.log(logTime)
            var todate=momenttz.tz(logTime, "Asia/Kolkata").format('DD');
            var tomonth=momenttz.tz(logTime, "Asia/Kolkata").format('MM');
            var toyear=momenttz.tz(logTime, "Asia/Kolkata").format('YYYY');
            var logDate=todate+'-'+tomonth+'-'+toyear;

        let data = {
            "OperationID": req.body.RealTime.OperationID,
            "Type": req.body.RealTime.PunchLog.Type,
            "InputType": req.body.RealTime.PunchLog.InputType,
            "UserId": req.body.RealTime.PunchLog.UserId,
            "LogTime": logTime,
            "AuthToken": req.body.RealTime.AuthToken,
            "Time": req.body.RealTime.Time,
            "checkInLocation":"Temple Adventures Pondicherry",
=======
            var logTime=moment(logTimeJS);
            logTime.tz("Asia/Kolkata").format();

            var logDate=momenttz.tz(logTime, "Asia/Kolkata").format('DD')
            +'-'+momenttz.tz(logTime, "Asia/Kolkata").format('MM')
            +'-'+momenttz.tz(logTime, "Asia/Kolkata").format('YYYY');

        let data = {
        //    "OperationID": req.body.RealTime.OperationID,
        //    "Type": req.body.RealTime.PunchLog.Type,
       //     "InputType": req.body.RealTime.PunchLog.InputType,
            "UserId": req.body.RealTime.PunchLog.UserId,
            "LogTime": logTime,
       //     "AuthToken": req.body.RealTime.AuthToken,
            "Time": req.body.RealTime.Time,
>>>>>>> kamesh/attendance
            "date":logDate
        }

    let attendanceLogData = await db.collection('employees')
    .doc(data.UserId)
    .collection('attendance')
    .doc(logDate).get();

         if(attendanceLogData.data() !== undefined){

                data.checkOutTime=data.LogTime;
                data.checkOutInput="TA-Biometric";
<<<<<<< HEAD
=======
                data.checkOutLocation="Temple Adventures Pondicherry";
>>>>>>> kamesh/attendance
                var logTimeOld = new Date(attendanceLogData.data().LogTime).getTime();
                var currentLogTime = new Date(data.LogTime).getTime();
                var diff = currentLogTime-logTimeOld;

                if(diff>600000){

<<<<<<< HEAD
                await db.collection('employees')
                .doc(data.UserId)
                .collection('attendance')
                .doc(logDate).set(data, {
                                               merge: true
                                           });
                }
                else{
                console.log("Old attendance is fresh");
                }
             }

                else
                {
             //   console.log("No log found.New data!!");
                   data.checkInTime=data.LogTime;
                   data.checkInInput="TA-Biometric";

                   await db.collection('employees').doc(data.UserId).
=======
                console.log("Old attendance is old. Updating ");
                await db.collection('employees')
                .doc(data.UserId)
                .collection('attendance')
                .doc(logDate).set(data, { merge: true });
                }
             }

             else
                {
                    console.log("No log found.New data!!");
                    data.checkInTime=data.LogTime;
                    data.checkInInput="TA-Biometric";
                    data.checkInLocation="Temple Adventures Pondicherry";
                    data.checkOutTime=null;
                    data.checkOutInput=null;
                    data.checkOutLocation=null;

                    await db.collection('employees').doc(data.UserId).
>>>>>>> kamesh/attendance
                                 collection('attendance').doc(logDate).set(data, {
                               merge: true
                           });

                let employeeShiftData = await db.collection('employees')
                    .doc(data.UserId)
//                    .collection('employeeFullInformation')
//                    .doc('employeeData')
                    .get();

                    var shiftTime = moment(employeeShiftData.data().shiftTiming,'HH:mm:ss');

                    shiftTime.tz('Asia/Kolkata',true).format();

                    var duration = logTime.diff(shiftTime);
                 //   console.log('Time Late in milisecs: '+duration)
                    var punctual ="";

                    if(duration>59000){
                    punctual="Late";


<<<<<<< HEAD
client.messages
  .create({
     body: 'Hi '+ employeeShiftData.data()
     .firstName + ', You are late to work today. You got to work at '+ logTime.format("hh:mm A"),
     from: twilioNumber,
     to: employeeShiftData.data().phoneNumber
   }).then(message => {
console.log(message.sid);
return null;
  }).catch((err) => {
                  throw (err);
              });




                    }else
                    {
                    punctual="On-Time";
                    }

                    let dailyData = {
                                    [data.UserId]: punctual+','+employeeShiftData.data()
                                                                     .firstName+' '+employeeShiftData.data()
                                                                                     .lastName
                                    }

                   await db.collection('dailyAttendanceLogs')
                   .doc(logDate)
                   .set(dailyData, {
                   merge: true
                   });
=======
                    client.messages
                    .create({
                                body: 'Hi '+ employeeShiftData.data()
                                .firstName + ', You are late to work today. You got to work at '
                                + logTime.format("hh:mm A"),
                                from: twilioNumber,
                                to: employeeShiftData.data().phoneNumber
                            }).then(message => {
                                                return null;
                                                })
                                                .catch((err) => {
                                                                throw (err);
                                                                });

                                        }
                                        else
                                            {
                                            punctual="On-Time";
                                            }


                    let dailyData = {
                                    [data.UserId]: {
                                                    "id":data.UserId,
                                                    "name":employeeShiftData.data()
                                                    .firstName+' '+employeeShiftData.data()
                                                    .lastName,
                                                    "phone":employeeShiftData.data()
                                                    .phoneNumber,
                                                    "shiftTime":employeeShiftData.data()
                                                    .shiftTiming,
                                                    "punctual":punctual,
                                                    "difference":duration,
                                                    "LogTime":logTime,
                                                    },
                                    }

             //       console.log(dailyData);

                   await db.collection('dailyAttendanceLogs')
                   .doc(logDate)
                   .set(dailyData,{
                                   merge: true
                                  });
>>>>>>> kamesh/attendance

                }

        res.send({
            "status": "done"
       })
    } catch (e) {
        res.send(e)
    }

<<<<<<< HEAD
})
=======
});

//exports.scheduledFunction = functions.pubsub.schedule('2 12 * * *')

exports.scheduledFunction = functions.pubsub.schedule('3 0 * * *')
.timeZone('Asia/Kolkata')
.onRun(async context=> {
  console.log('This is running early morning!! GCP needs coffee!');

  let dailyAttendanceTemplate = await db.collection('dailyAttendanceLogs')
                      .doc('template')
                      .get();

            var today=new Date();
            var todayMoment=moment(today);
            var todayDate=momenttz.tz(todayMoment, "Asia/Kolkata").format('DD')
            +'-'+momenttz.tz(todayMoment, "Asia/Kolkata").format('MM')
            +'-'+momenttz.tz(todayMoment, "Asia/Kolkata").format('YYYY');


   await db.collection('dailyAttendanceLogs')
                       .doc(todayDate)
                       .set(dailyAttendanceTemplate.data());

  return null;
});


>>>>>>> kamesh/attendance

exports.getAttendanceLog = functions.https.onRequest(async (req, res) => {
    try {
        const OperationID  = req.body.OperationID;
       
        let attendanceLogData = await db.collection('attendanceLog').doc(OperationID).get();
        //console.log(attendanceLogData.data())
        if(attendanceLogData.data() !== null){
            res.send({
                "status": "done",
                "attendanceLogData": attendanceLogData.data()
           })
        }else{
            res.send({
                "status": "No Data available",
           })
        }
       
    } catch (e) {
        res.send(e)
    }

<<<<<<< HEAD
})
=======
});
>>>>>>> kamesh/attendance
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
