import React, { Component } from "react"
import classes from "./LandingPage.module.css"
import logo from "../../assets/Logo.png"

class LandingPage extends Component {

    state = {
        emailIn: "",
        firstIn: "",
        lastIn: "",
        isSubmitted: false
    }

    sendEmail = () => {
        fetch("https://justifi.uc.r.appspot.com/api/email/newSignup", {
            method: "POST",
            withCredentials: true,
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ 
                first: this.state.firstIn,
                last: this.state.lastIn,
                email: this.state.emailIn
             }),
          });

          this.setState({firstIn:""})
          this.setState({lastIn:""})
          this.setState({emailIn:""})
          this.setState({isSubmitted:true})
    }

    updateFirstName = (e) => {
        this.setState({firstIn:e.target.value})
        this.setState({isSubmitted:false})
    }

    updateLastName = (e) => {
        this.setState({lastIn:e.target.value})
        this.setState({isSubmitted:false})
    }

    updateEmail = (e) => {
        this.setState({emailIn:e.target.value})
        this.setState({isSubmitted:false})
    }

    render() {
        return (
            <div className={classes.landingWrapper}>
                <div className={classes.imageWrapper}>
                    <img className={classes.actualImage} src={logo}></img>
                </div>
                <p className={classes.para}>If you would like access to our our beta, please enter your info below and we will do our best to get you access to the app!</p>
                <div className={classes.inputGroup}>
                    <div className={classes.nameGroup}>
                        <input className={classes.firstNameInput} value={this.state.firstIn} onChange={this.updateFirstName} placeholder="Lebron"></input>
                        <input className={classes.lastNameInput} value={this.state.lastIn} onChange={this.updateLastName} placeholder="Musk"></input>
                    </div>
                    <div className={classes.emailGroup}>
                        <input placeholder="MuskDaddyS3XY@hotmail.com" value={this.state.emailIn} onChange={this.updateEmail} className={classes.emailInput}></input>
                        <button className={classes.submitButton} onClick={this.sendEmail}>Submit</button>
                    </div>
                </div>
                <p style={this.state.isSubmitted ? {opacity: 1} : {opacity: 0}}className={classes.submittedPara}>Email Submitted!</p>
            </div>
        )
    }
}
export default LandingPage