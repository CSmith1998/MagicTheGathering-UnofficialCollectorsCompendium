using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using Xunit;

namespace MtG_UCC_Testing {
    public class IdentityTests : IDisposable {
        public const string baseUrl = "https://localhost:7038/";

        public WebDriver driver;

        public IdentityTests() {
            driver = new FirefoxDriver();
            driver.Navigate().GoToUrl(baseUrl);
        }

        [Theory,
            InlineData("cls56@students.ptcollege.edu", "1StrangeFamily!"),
            InlineData("KageSanguis@gmail.com", "1StrangeFamily!"),
            InlineData("shadownightstrider@gmail.com", "1Strangefamily!")]
        public void TestLoginCaptcha(String email, String password) { 
            driver.FindElement(By.Id("LoginLink")).Click();
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(5);

            if(driver.Url.Equals(String.Format("{0}Identity/Account/Login", baseUrl))) {
                driver.FindElement(By.Id("LoginEmail")).SendKeys(email);
                driver.FindElement(By.Id("LoginPassword")).SendKeys(password);
                driver.FindElement(By.Id("login-submit")).Click();

                var error = driver.FindElement(By.XPath("/html/body/div[1]/main/div/div/section/form/div[1]/ul/li"));
                if(error.Text.Equals("The reCAPTCHA response is invalid.")) {
                    Assert.True(true, "Captcha successfully blocked login attempt.");
                } else Assert.True(false, "Captcha failed to block login attempt.");
            } else Assert.True(false, "Login Page did not open!");
        }

        [Theory,
            InlineData("cls56@students.ptcollege.edu", "1StrangeFamily!"),
            InlineData("KageSanguis@gmail.com", "1StrangeFamily!"),
            InlineData("shadownightstrider@gmail.com", "1Strangefamily!")]
        public void TestRegisterCaptcha(String email, String password) {
            driver.FindElement(By.Id("RegisterLink")).Click();
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(5);

            if(driver.Url.Equals(String.Format("{0}Identity/Account/Register", baseUrl))) {
                driver.FindElement(By.Id("RegisterEmail")).SendKeys(email);
                driver.FindElement(By.Id("RegisterPassword")).SendKeys(password);
                driver.FindElement(By.Id("RegisterPassConfirm")).SendKeys(password);
                driver.FindElement(By.Id("registerSubmit")).Click();

                var error = driver.FindElement(By.XPath("/html/body/div[1]/main/div/div/form/div[1]/ul/li"));
                if(error.Text.Equals("The reCAPTCHA response is invalid.")) {
                    Assert.True(true, "Captcha successfully blocked registration attempt.");
                } else Assert.True(false, "Captcha failed to block registration attempt.");
            } else Assert.True(false, "Registration Page did not open!");
        }

        public void Dispose() {
            driver.Close();
            driver.Dispose();
        }
    }
}
