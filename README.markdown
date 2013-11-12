## TicketingHub-ios

A library for interacting with the TicketingHub
[Developer API](https://www.ticketinghub.com/api) from an iOS device.

### Dependencies

* AFNetworking (MIT Licence), added as a submodule to the repository already

If running the tests target, then there is a further dependency on Specta,
Expecta and OHHTTPStubs which are already added as submodules.

It's a good idea to add these lines to the project's pch file:

    @import SystemConfiguration;
    @import MobileCoreServices;
    @import Security;

Xcode 5's module support means that the relevant libraries will be included
automatically.






