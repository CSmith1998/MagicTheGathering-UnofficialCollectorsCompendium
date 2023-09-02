using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Xunit;

namespace MtG_UCC_Testing
{
    public static class WebDriverExtensions {
        public static IWebElement FindElement(this IWebDriver driver, By by, int timeoutInSeconds) {
            if(timeoutInSeconds > 0) {
                var wait = new WebDriverWait(driver, TimeSpan.FromSeconds(timeoutInSeconds));
                return wait.Until(drv => drv.FindElement(by));
            }
            return driver.FindElement(by);
        }

        public static IWebElement WaitUntilVisible(this IWebDriver driver, By by, int timeoutInSeconds = 5) {
            var wait = new WebDriverWait(driver, new TimeSpan(0, 0, timeoutInSeconds));
            var element = wait.Until<IWebElement>(driver => {
                try { 
                    var elementToBeDisplayed = driver.FindElement(by);
                    if (elementToBeDisplayed.Displayed) {
                        return elementToBeDisplayed;
                    }
                    return null;
                } catch (StaleElementReferenceException) {
                    return null;
                } catch (NoSuchElementException) {
                    return null;
                }
            });
            return element;
        }
    }
}
