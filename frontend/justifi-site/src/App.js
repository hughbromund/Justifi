import './App.css';
import "./Components/LandingPage/LandingPage"
import LandingPage from './Components/LandingPage/LandingPage';
import AppName from "./Components/AppName/AppName"

function App() {
  return (
    <div className="App">
      <AppName />
      <LandingPage />
    </div>
  );
}

export default App;
