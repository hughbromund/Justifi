import React, {Component} from "react"
import classes from "./AppName.module.css"

class AppName extends Component {
    render() {
        return (
            <div className={classes.appNameWrapper}>
                <div className={classes.title}><span className={classes.j}>J</span>ustifi</div>
            </div>
        )
    }
}

export default AppName