> # Non-Functional Requirements

## Speed

While speed is not the highest priority for the Dialogue Time app, it should still be fast enough to meet users' expectations. As a sovereign posture type application, users are not deterred away from Dialogue Time due to its speed. However, it is important to ensure that the application meets users' expectations. Users do not expect to wait excessively long for the application to render, and as such, it should be designed to perform optimally within reasonable timeframes.

## Security

The Dialogue Time app is not responsible for account management, as it is one of the most significant administrative overheads that can be resolved with automation. To address this requirement, the app may integrate Microsoft Graph services, which can be used to implement Single Sign-On (SSO) and reduce the burden of account management. Therefore, this non-functional requirement's scope includes integrating Microsoft Graph services to enable SSO and streamline account management.

- Account management.
- Account locking.
- Password generation.
- Security question answering.

## Portability

The application must be designed to provide universal access from any location, without any geographical or time-zone restrictions. This requirement is essential as many consultants work remotely, and the application must be accessible from anywhere in the world to ensure seamless operation. Therefore, the application should be designed to be accessible over the internet and not restricted to any specific physical location or network.

## Localization

To make the application more user-friendly, it is essential to take into account the users' locale, including their time zone and language. This can be achieved by implementing features such as auto-detection of the user's time zone based on their location or user preferences, and providing language options for users to choose from.

For example, the application can automatically adjust the displayed time and date based on the user's location or time zone, ensuring that the schedules and notifications are accurate and relevant to the user. Additionally, the application can provide language options for users to select from, enabling them to access the platform in their preferred language.

By considering the users' locale, the application can offer a more personalized and user-friendly experience, improving user satisfaction and engagement.

## Compatibility

To add to the previous answer, ensuring the application is highly compatible with all devices would involve using responsive design techniques to optimize the user experience across different screen sizes and resolutions. This would involve designing layouts that can adapt and adjust to different device sizes, using flexible images and media, and prioritizing content and functionality based on the device being used.

It's also important to conduct thorough testing on different devices and platforms to ensure the application performs well and is accessible to all users.

## Reliability

Achieving less than 0.1% downtime means that the application must have a highly available architecture, which should include redundant servers, load balancers, and other failover mechanisms. It's also essential to have a reliable backup and disaster recovery plan in place to ensure that data is safe and recoverable in the event of a catastrophic failure.

To achieve this level of reliability, it's important to conduct regular testing and monitoring to identify potential issues and resolve them before they become problems. The use of automated testing and monitoring tools can help to detect issues early and allow for quick resolution.

It's also important to have a team dedicated to maintaining and monitoring the application's infrastructure and ensuring that it is up to date with the latest security patches and updates. This team should be available around the clock to quickly respond to any issues that arise and ensure that the application remains highly reliable.

## Navigation

To ensure that consultants can use the application effectively, it is important to make sure that the application is easy to navigate. This means that menus and options should be clearly labeled and organized in a way that is intuitive for the user. It is also important to avoid clutter and unnecessary information, so that users can quickly find what they need. By making the application easy to navigate, consultants will be able to find what they need more quickly, reducing the time they spend on administrative tasks and increasing their productivity.

## Purposefull

The development of features for the new Dialogue Time application must align with the actual business needs related to the tool. While there may be requests for nice-to-have features from various departments, the focus should be on creating a centralized environment that increases automation and reduces administrative overhead. It's important to remember that the application is intended to be a tool, not a replacement for existing work processes. Any features developed should be relevant and aligned with work processes to ensure maximum efficiency.
