================================================
FILE: README.md
================================================
---
description: Maestro is the simplest and most effective UI testing framework.
---

# What is Maestro?

{% hint style="success" %}
🚀  **Running in the Cloud**

Ready to wire into CI or scale up your testing? Start running your flows on Maestro's enterprise-grade cloud infrastructure: [**Run Maestro tests in the cloud**](cloud/run-maestro-tests-in-the-cloud.md)
{% endhint %}

{% embed url="https://vimeo.com/767721667/d972c5f08e" %}

## Why Maestro?

Maestro is built on learnings from its predecessors (Appium, Espresso, UIAutomator, XCTest, Selenium, Playwright) and allows you to easily define and test your Flows.

{% hint style="info" %}
**What are Flows?** Think of Flows as parts of the user journey in your app. Login, Checkout and Add to Cart are three examples of possible Flows that can be defined and tested using Maestro.
{% endhint %}

* Built-in tolerance to flakiness. UI elements will not always be where you expect them, screen tap will not always go through, etc. Maestro embraces the instability of mobile applications and devices and tries to counter it.
* Built-in tolerance to delays. No need to pepper your tests with `sleep()` calls. Maestro knows that it might take time to load the content (i.e. over the network) and automatically waits for it (but no longer than required).
* Blazingly fast iteration. Tests are interpreted, no need to compile anything. Maestro is able to continuously monitor your test files and rerun them as they change.
* Declarative yet powerful syntax. Define your tests in a `yaml` file.
* Simple setup. Maestro is a single binary that works anywhere.

## Examples

#### Twitter (Mobile)

<figure><img src=".gitbook/assets/twitter_continuous_v3_fast.gif" alt=""><figcaption></figcaption></figure>

#### Simple Examples

{% tabs %}
{% tab title="Android" %}
```yaml
# flow_contacts_android.yaml

appId: com.android.contacts
---
- launchApp
- tapOn: "Create new contact"
- tapOn: "First Name"
- inputText: "John"
- tapOn: "Last Name"
- inputText: "Snow"
- tapOn: "Save"
```
{% endtab %}

{% tab title="iOS" %}
```yaml
# flow_contacts_ios.yaml

appId: com.apple.MobileAddressBook
---
- launchApp
- tapOn: "John Appleseed"
- tapOn: "Edit"
- tapOn: "Add phone"
- inputText: "123123"
- tapOn: "Done"
```
{% endtab %}

{% tab title="Web" %}
```yaml
url: https://example.com
---
- launchApp
- tapOn: More information...
- assertVisible: Further Reading
```
{% endtab %}
{% endtabs %}

## Platform Support

<table><thead><tr><th width="572">Platform</th><th align="center">Supported</th></tr></thead><tbody><tr><td><a href="platform-support/android-views.md">Android - Views</a></td><td align="center">✅</td></tr><tr><td><a href="platform-support/android-jetpack-compose.md">Android - Jetpack Compose</a></td><td align="center">✅</td></tr><tr><td><a href="platform-support/ios-uikit.md">iOS - UIKit</a></td><td align="center">✅</td></tr><tr><td><a href="platform-support/ios-swiftui.md">iOS - SwiftUI</a></td><td align="center">✅</td></tr><tr><td><a href="platform-support/react-native.md">React Native</a></td><td align="center">✅</td></tr><tr><td><a href="platform-support/flutter.md">Flutter</a></td><td align="center">✅</td></tr><tr><td><a href="platform-support/web-views.md">Web Views</a></td><td align="center">✅</td></tr><tr><td><a href="platform-support/web-desktop-browser.md">Web (Desktop Browser)</a></td><td align="center">✅</td></tr><tr><td>.NET MAUI iOS</td><td align="center">✅</td></tr><tr><td>.NET MAUI Android</td><td align="center">✅</td></tr></tbody></table>

## Resources

* Blog Post: [**Introducing: Maestro — Painless Mobile UI Automation**](https://blog.mobile.dev/introducing-maestro-painless-mobile-ui-automation-bee4992d13c1)
* GitHub Repository: [**https://github.com/mobile-dev-inc/maestro**](https://github.com/mobile-dev-inc/maestro)
* Public Slack Channel: [**Join the workspace**](https://docsend.com/view/3r2sf8fvvcjxvbtk), then head to the `#maestro` channel



## Get Started

Get started by installing the Maestro CLI:



================================================
FILE: LICENSE
================================================
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.



================================================
FILE: migrating-from-maestro-cloud.md
================================================
---
hidden: true
---

# Migrating from Maestro Cloud

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

## Maestro Cloud to Robin Migration Guide

Welcome to the migration guide for transitioning from **Maestro Cloud** to **Robin**. This guide will help you update your integration—whether using a **Continuous Integration (CI) system** or the **Command Line Interface (CLI)**—with the necessary changes to smoothly switch to Robin.

***

{% hint style="info" %}
TLDR: simply update your CI integration / maestro CLI and pass your new Robin API key and project id along. Example:

```
maestro cloud --api-key <ROBIN_API_KEY> --project-id <ROBIN_PROJECT_ID> <appFile> <flows>
```
{% endhint %}

### Overview

If you’re migrating from **Maestro Cloud** to **Robin**, you will need to update either your CI integration or CLI tool with:

1. A new API key for Robin
2. The project ID for your project
3. Specify what iOS / Android API level if you don't want to run the Robin default (which is iOS 16 / Android API 33)

This documentation will walk you through the steps to obtain these and update your existing setups which can be completed in **minutes**.

### Step 1: Obtain your API Key

Please reach out to your mobile.dev representative to obtain your secret API key.

_Note: Treat your API key like a password. Do not share it publicly._

### Step 2: Obtain your your Project ID

1. Go to the Robin console
2. Navigate to Settings
3. Copy the Project ID

<figure><img src=".gitbook/assets/Screenshot 2024-10-16 at 09.49.09.png" alt=""><figcaption></figcaption></figure>

This project ID will be required in both your CI and CLI updates and is **not secret**.

### Step 3: Update your setup

**If you're using the Maestro CLI**

Simply use your new API key and pass `--project-id` along with the `maestro cloud` call and you'll be all set!

For example, the following command when using Maestro Cloud

```
maestro cloud --api-key <MAESTRO_CLOUD_API_KEY> <app> <flows>
```

updated to upload to Robin looks like this

```
maestro cloud --api-key <ROBIN_API_KEY> --project-id <ROBIN_PROJECT_ID> <app> <flows>
```

**If you're using a CI integration**

CI Integrations have been updated to support specifying the Robin Project ID - please refer to the [CI Integration docs](cloud/ci-integration/) to learn how to set up your specific CI integration with your new API Key and Robin Project ID.

**Updating device OS version**

{% hint style="warning" %}
Make sure that you specify the intended OS version - the defaults are different in Robin compared to Maestro Cloud
{% endhint %}

The default OS versions for Robin are iOS 16 and Android API level 33, which is different from Maestro Cloud, which had defaults of iOS 15 and API level 30.  Please refer to the docs below with information on how to configure OS version.

{% content-ref url="cloud/reference/configuring-os-version.md" %}
[configuring-os-version.md](cloud/reference/configuring-os-version.md)
{% endcontent-ref %}

### Troubleshooting

Here are some common issues and solutions:

* **Invalid API Key**: Ensure the API key is copied correctly and not expired.
* **Missing Project ID**: Double-check that the project ID in the Robin portal matches the one in your configuration.
* **Authentication Errors**: Verify that the API key has the correct permissions for the actions you're trying to perform.

For further assistance, consult the Robin support team or check the Robin Documentation.

***

By following these steps, you will successfully migrate from Maestro Cloud to Robin. If you encounter any issues, refer to the troubleshooting section or reach out to support.



================================================
FILE: SUMMARY.md
================================================
# Table of contents

* [Home](https://www.maestro.dev)
* [Star us on GitHub](https://github.com/mobile-dev-inc/maestro)

## Getting Started

* [What is Maestro?](README.md)
* [Installing Maestro](getting-started/installing-maestro/README.md)
  * [macOS](getting-started/installing-maestro/macos.md)
  * [Windows](getting-started/installing-maestro/windows.md)
  * [Linux](getting-started/installing-maestro/linux.md)
* [Build and Install your App](getting-started/build-and-install-your-app/README.md)
  * [Android](getting-started/build-and-install-your-app/android.md)
  * [iOS](getting-started/build-and-install-your-app/ios.md)
* [Run a Sample Flow](getting-started/run-a-sample-flow.md)
* [Writing Your First Flow](getting-started/writing-your-first-flow.md)
* [Maestro Studio](getting-started/maestro-studio.md)
* [Running Flows on CI](getting-started/running-flows-on-ci.md)

## Cloud

* [Run Maestro tests in the cloud](cloud/run-maestro-tests-in-the-cloud.md)
* [Cloud Quickstart](cloud/cloud-quickstart.md)
* [CI Integration](cloud/ci-integration/README.md)
  * [GitHub Actions](cloud/ci-integration/github-actions/README.md)
    * [Maestro GitHub Action for Android](cloud/ci-integration/github-actions/maestro-github-action-for-android.md)
    * [Maestro GitHub Action for iOS](cloud/ci-integration/github-actions/maestro-github-action-for-ios.md)
    * [Maestro GitHub Action for Flutter](cloud/ci-integration/github-actions/maestro-github-action-for-flutter.md)
  * [Bitrise](cloud/ci-integration/bitrise.md)
  * [Bitbucket Pipelines](cloud/ci-integration/bitbucket-pipelines.md)
  * [CircleCI](cloud/ci-integration/circleci.md)
  * [Integration with any CI platform](cloud/ci-integration/integration-with-any-ci-platform.md)
* [Pull Request Integration](cloud/pull-request-integration.md)
* [Cloud Reference](cloud/reference/README.md)
  * [Build your app for the cloud](cloud/reference/build-your-app-for-cloud.md)
  * [Configuring OS Version](cloud/reference/configuring-os-version.md)
  * [Configuring device locale](cloud/reference/configuring-device-locale.md)
  * [Device timezones](cloud/reference/device-timezones.md)
  * [Email Notifications](cloud/reference/email-notifications.md)
  * [Slack Notifications](cloud/reference/slack-notifications.md)
  * [Webhook Integration](cloud/reference/webhook-integration.md)
  * [Managing Secrets](cloud/reference/managing-secrets.md)
  * [Limits](cloud/reference/limits.md)
  * [Reusing App Binary](cloud/reference/reusing-app-binary.md)
  * [IP Allowlist](cloud/reference/ip-allowlist.md)
  * [System Status](https://status.mobile.dev/)

***

* [Migrating from Maestro Cloud](migrating-from-maestro-cloud.md)

## Platform Support

* [Supported Platforms](platform-support/supported-platforms.md)
* [Android - Views](platform-support/android-views.md)
* [Android - Jetpack Compose](platform-support/android-jetpack-compose.md)
* [iOS - UIKit](platform-support/ios-uikit.md)
* [iOS - SwiftUI](platform-support/ios-swiftui.md)
* [React Native](platform-support/react-native.md)
* [Flutter](platform-support/flutter.md)
* [Web Views](platform-support/web-views.md)
* [Web (Desktop Browser)](platform-support/web-desktop-browser.md)

## Examples

* [Android contacts flow automation](examples/android-contacts-flow-automation.md)
* [Facebook signup flow automation](examples/facebook-signup-flow-automation.md)
* [Advanced: Wikipedia Android](examples/advanced-wikipedia-android.md)
* [Page Object Model](examples/page-object-model.md)

## CLI

* [Cloud](cli/cloud.md)
* [Test Suites & Reports](cli/test-suites-and-reports.md)
* [Tags](cli/tags.md)
* [Record Your Flow](cli/recording-your-flow.md)
* [Continuous Mode](cli/continuous-mode.md)
* [View Hierarchy](cli/view-hierarchy.md)
* [Start Device](cli/start-device.md)

## API Reference

* [Commands](api-reference/commands/README.md)
  * [addMedia](api-reference/commands/addmedia.md)
  * [assertVisible](api-reference/commands/assertvisible.md)
  * [assertNotVisible](api-reference/commands/assertnotvisible.md)
  * [assertTrue](api-reference/commands/asserttrue.md)
  * [assertWithAI](api-reference/commands/assertwithai.md)
  * [assertNoDefectsWithAi](api-reference/commands/assertnodefectswithai.md)
  * [back](api-reference/commands/back.md)
  * [clearKeychain](api-reference/commands/clearkeychain.md)
  * [clearState](api-reference/commands/clearstate.md)
  * [copyTextFrom](api-reference/commands/copytextfrom.md)
  * [evalScript](api-reference/commands/evalscript.md)
  * [eraseText](api-reference/commands/erasetext.md)
  * [extendedWaitUntil](api-reference/commands/extendedwaituntil.md)
  * [extractTextWithAI](api-reference/commands/extracttextwithai.md)
  * [hideKeyboard](api-reference/commands/hidekeyboard.md)
  * [inputText](api-reference/commands/inputtext.md)
  * [killApp](api-reference/commands/killapp.md)
  * [launchApp](api-reference/commands/launchapp.md)
  * [openLink](api-reference/commands/openlink.md)
  * [pressKey](api-reference/commands/presskey.md)
  * [pasteText](api-reference/commands/pastetext.md)
  * [repeat](api-reference/commands/repeat.md)
  * [retry](api-reference/commands/retry.md)
  * [runFlow](api-reference/commands/runflow.md)
  * [runScript](api-reference/commands/runscript.md)
  * [scroll](api-reference/commands/scroll.md)
  * [scrollUntilVisible](api-reference/commands/scrolluntilvisible.md)
  * [setAirplaneMode](api-reference/commands/setairplanemode.md)
  * [setLocation](api-reference/commands/setlocation.md)
  * [startRecording](api-reference/commands/startrecording.md)
  * [stopApp](api-reference/commands/stopapp.md)
  * [stopRecording](api-reference/commands/stoprecording.md)
  * [swipe](api-reference/commands/swipe.md)
  * [takeScreenshot](api-reference/commands/takescreenshot.md)
  * [toggleAirplaneMode](api-reference/commands/toggleairplanemode.md)
  * [tapOn](api-reference/commands/tapon.md)
  * [doubleTapOn](api-reference/commands/doubletapon.md)
  * [longPressOn](api-reference/commands/longpresson.md)
  * [travel](api-reference/commands/travel.md)
  * [waitForAnimationToEnd](api-reference/commands/waitforanimationtoend.md)
* [Common command arguments](api-reference/common-commands-arguments.md)
* [Selectors](api-reference/selectors.md)
* [Configuration](api-reference/configuration/README.md)
  * [Workspace configuration](api-reference/configuration/workspace-configuration.md)
  * [Flow configuration](api-reference/configuration/flow-configuration.md)
  * [AI configuration](api-reference/configuration/ai-configuration.md)

## Advanced

* [Nested Flows](advanced/nested-flows.md)
* [Wait](advanced/wait.md)
* [Loops](advanced/loops.md)
* [Conditions](advanced/conditions.md)
* [Parameters & Constants](advanced/parameters-and-constants.md)
* [JavaScript](advanced/javascript/README.md)
  * [Run JavaScript](advanced/javascript/run-javascript.md)
  * [Outputs](advanced/javascript/outputs.md)
  * [Logging](advanced/javascript/logging.md)
  * [Access element text](advanced/javascript/access-element-text.md)
  * [Make HTTP requests](advanced/javascript/make-http-s-requests.md)
  * [GraalJS support](advanced/javascript/graaljs-support.md)
  * [JavaScript announcement blog](https://blog.mobile.dev/maestro-announcing-javascript-http-request-support-b2db06e1db00)
* [Specify a Device](advanced/specify-a-device.md)
* [Configure Permissions](advanced/configuring-permissions.md)
* [Detect Maestro in your app](advanced/detect-maestro-in-your-app.md)
* [Configure Maestro driver timeout](advanced/configuring-maestro-driver-timeout.md)
* [onFlowStart / onFlowComplete hooks](advanced/onflowstart-onflowcomplete-hooks.md)
* [Test in different locales](advanced/testing-in-different-locales.md)
* [Structuring your test suite](https://blog.mobile.dev/maestro-best-practices-structuring-your-test-suite-54ec390c5c82)

## Troubleshooting

* [Known Issues](troubleshooting/known-issues.md)
* [Frequently Asked Questions](troubleshooting/frequently-asked-questions.md)
* [Bug Report](troubleshooting/bug-report.md)
* [Rollback Maestro](troubleshooting/rollback-maestro.md)
* [Debug Output](troubleshooting/debug-output.md)
* [HOWTOs](troubleshooting/howtos/README.md)
  * [scrollUntilVisible for fragments](troubleshooting/howtos/scrolluntilvisible-for-fragments.md)

## Community

* [Contributions](community/contributions.md)
* [Articles & Tutorials](community/articles-and-tutorials.md)
* [Resources](community/resources.md)



================================================
FILE: .gitbook.yaml
================================================
root: ./

structure:
  readme: README.md
  summary: SUMMARY.md

redirects:
  api-reference/labels: api-reference/commands/README.md



================================================
FILE: advanced/conditions.md
================================================
# Conditions

{% hint style="warning" %}
By design, Maestro discourages the usage of conditional statements unless absolutely necessary as they could easily ramp up the complexity of your tests.
{% endhint %}

### runFlow conditionally

```yaml
- runFlow:
    when:
      visible: 'Some Text'
    file: folder/some-flow.yaml
```

{% content-ref url="nested-flows.md" %}
[nested-flows.md](nested-flows.md)
{% endcontent-ref %}

Or, if you don't wish to extract your commands into a separate flow file, you can run the commands inline like this:

```yaml
- runFlow:
    when:
      visible: 'Some Text'
    commands:
        - tapOn: 'Some Text'
```

{% content-ref url="../api-reference/commands/runflow.md" %}
[runflow.md](../api-reference/commands/runflow.md)
{% endcontent-ref %}

### runScript conditionally

```yaml
- runScript:
    when:
      visible: 'Some Text'
    file: some-script.js
```

{% content-ref url="../api-reference/commands/runscript.md" %}
[runscript.md](../api-reference/commands/runscript.md)
{% endcontent-ref %}

### Multiple conditions

```yaml
- runFlow:
    when:
      visible: 'Some Text'
      platform: iOS
    file: folder/some-flow.yaml
```

Note that multiple conditions are applied as AND conditions.

### Conditions

Supported conditions include:

<pre class="language-yaml"><code class="lang-yaml"><strong>visible: { Element matcher }        # True if matching element is visible
</strong>notVisible: { Element matcher }     # True if matching element is not present
true: { Value }                     # True if given value is true or not empty
platform: { Platform }              # True if current platform is given platform (Android|iOS|Web)
</code></pre>

All of the normal element matchers are supported, e.g.

```yaml
- runFlow:
    when:
      visible:
        id: 'someId'
        text: 'Some Text'
        below:
          text: 'Some Other Text'
        childOf:
          id: 'someParentId'
          text: 'Some Parent Text'
        index: 2
    file: folder/some-flow.yaml
```

{% content-ref url="../api-reference/selectors.md" %}
[selectors.md](../api-reference/selectors.md)
{% endcontent-ref %}

### JavaScript

Usage of JavaScript conditions is possible via `true` condition:

```yaml
- runFlow:
    when:
      true: ${MY_PARAMETER == 'Something'}
    file: subflow.yaml
```

{% content-ref url="javascript/" %}
[javascript](javascript/)
{% endcontent-ref %}



================================================
FILE: advanced/configuring-maestro-driver-timeout.md
================================================
# Configuring Maestro driver timeout

In some environments with limited performance, such as CI/CD, it may be necessary to increase the maestro driver's default timeout. For this, you can set the environment `MAESTRO_DRIVER_STARTUP_TIMEOUT`, setting how many milliseconds you want.

The default value is `15000` (15 seconds)

Example

```
export MAESTRO_DRIVER_STARTUP_TIMEOUT=60000 # setting 60 seconds
maestro test file.yaml
```



================================================
FILE: advanced/configuring-permissions.md
================================================
# Configure Permissions

By default, all permissions are set to `allow` by the launchApp command. It is
possible to launch an app with custom permissions behaviour by passing the
`permissions` argument to `launchApp`:

```yaml
- launchApp:
    permissions:
      all: deny
      camera: allow
      location: allow
```


## Available permissions

Maestro has standardized names for most permissions.

For example, on Android: `bluetooth` targets both `android.permission.BLUETOOTH_CONNECT` and `android.permission.BLUETOOTH_SCAN`.

| Permission           | iOS support | Android support |
|----------------------|-------------|-----------------|
| calendar             | ✅          | ✅              |
| camera               | ✅          | ✅              |
| contacts             | ✅          | ✅              |
| health               | ❌          | ❌              |
| homekit              | ✅          | ❌              |
| location             | ✅          | ✅              |
| medialibrary         | ✅          | ✅              |
| microphone           | ✅          | ✅              |
| motion               | ✅          | ❌              |
| notifications        | ✅          | ✅              |
| photos               | ✅          | ❌              |
| reminders            | ✅          | ❌              |
| siri                 | ✅          | ❌              |
| speech               | ✅          | ❌              |
| usertracking         | ✅          | ❌              |
| bluetooth            | ❌          | ✅              |
| phone                | ❌          | ✅              |
| storage              | ❌          | ✅              |
| sms                  | ❌          | ✅              |
| my.custom.permission | ❌          | ✅              |

{% hint style="info" %}
Use `all` as a permission name to represent all the permissions that the app can ask for.
{% endhint %}

### Supporting permission IDs for Android

There are permissions on Android that are not listed in the table above. Use the
permission IDs in place of the permission name to set these permissions.

For example, to allow the "add voicemail" permission, use:

```yaml
- launchApp:
    permissions:
        com.android.voicemail.permission.ADD_VOICEMAIL: allow
```

## Available permission names

Every permission can be set to: `allow`, `deny` or `unset`

| Permission Value | iOS                                      | Android                                  |
| ---------------- | ---------------------------------------- | ---------------------------------------- |
| allow            | Permission granted                       | Permission granted                       |
| deny             | Permission denied                        | Permission will be asked during flow run |
| unset            | Permission will be asked during flow run | Permission will be asked during flow run |

Some iOS permissions can have other values:

| Permission | Value   | Description                              |
| ---------- | ------- | ---------------------------------------- |
| location   | always  | Same as allow                            |
|            | inuse   | Only allow location whilst using the app |
|            | never   | Same as deny                             |
| photos     | limited | Allow limited access to photos           |

## Examples

Permissions are set by passing them to the `launchApp` command as follows:

### Deny all permissions

```yaml
- launchApp:
    permissions: { all: deny } 
```

### Deny all permissions but allow the `medialibrary` permission

```yaml
- launchApp:
    permissions:
        all: deny
        medialibrary: allow
```

### Deny all permissions but allow adding voicemails

```yaml
- launchApp:
    permissions:
        all: deny
        com.android.voicemail.permission.ADD_VOICEMAIL: allow
```



================================================
FILE: advanced/detect-maestro-in-your-app.md
================================================
# Detect Maestro in your app

{% tabs %}
{% tab title="Mobile" %}
## Using launch arguments

The recommended way to check if maestro is currently running is to use [arguments](../api-reference/commands/launchapp.md#launch-arguments) and have your app detect a particular parameter to indicate Maestro's usage, e.g. `isE2ETest`.

## Checking for open ports (deprecated)

{% hint style="warning" %}
Using ports is deprecated and may stop working at any time in future maestro updates and is not supported when [running in the cloud](../cloud/run-maestro-tests-in-the-cloud.md).
{% endhint %}



It's sometimes useful to be able to add logic in your app that depends that whether you are running within the context of Maestro. In order to detect Maestro, check to see whether the Maestro-specific port is open on your device:

<table><thead><tr><th width="146">Platform</th><th>Maestro Port on Device</th></tr></thead><tbody><tr><td>iOS</td><td>22087</td></tr><tr><td>Android</td><td>7001</td></tr></tbody></table>

Here's an example of how to check for Maestro in an Android app:

```kotlin
fun isMaestro(): Boolean {
    return try {
        Socket("localhost", 7001).use { true }
    } catch(ignored: IOException) {
        false
    }
}
```

### NetworkOnMainThreadException

On Android, you may encounter a `NetworkOnMainThreadException`. This means you'll need to move the call above to a background thread. As an example:

```kotlin
CoroutineScope(Dispatchers.IO).launch {
    if (isMaestro()) {
        // Do Maestro things
        
    }
}
```
{% endtab %}

{% tab title="Web" %}
## Using JS property

Maestro defines `window.maestro` property during test execution, so you can simply check if it is defined to check whether your app is running under a Maestro test:

```javascript
if (window.maestro) {
  console.log("Maestro test is running!");
}
```
{% endtab %}
{% endtabs %}






================================================
FILE: advanced/loops.md
================================================
# Loops

If you want to use loops in your Flows you can make use of the `repeat` command:

{% content-ref url="../api-reference/commands/repeat.md" %}
[repeat.md](../api-reference/commands/repeat.md)
{% endcontent-ref %}



================================================
FILE: advanced/nested-flows.md
================================================
# Nested Flows

If you want to avoid code duplication and make use of Nested Flows, please refer to the documentation for the [runFlow](../api-reference/commands/runflow.md) command.

#### Run flows conditionally

Sometimes you'd want to run flows only under certain conditions. Check out more in the page below

{% content-ref url="conditions.md" %}
[conditions.md](conditions.md)
{% endcontent-ref %}



================================================
FILE: advanced/onflowstart-onflowcomplete-hooks.md
================================================
# onFlowStart / onFlowComplete hooks

### General

If some logic needs to be executed before the start or after the completion of maestro flow onStart and onComplete hooks can be used.\
\
The hooks are a part of [flow configuration section](../api-reference/configuration/flow-configuration.md).

Basic usage of an API could look like that:

```
# flow.yaml
appId: my.app
onFlowStart:
  - runFlow: setup.yaml
  - runScript: setup.js
  - <any other command>
onFlowComplete:
  - runFlow: teardown.yaml
  - runScript: teardown.js
  - <any other command>
```

### What if one of the hooks fails?

In case of either **onFlowStart** / **onFlowComplete** failure the behavior of maestro is consistent with JUnit (@before / @after) and XCTest (setup / teardown) hooks.

| Test case                                                                        | Behavior                            |
| -------------------------------------------------------------------------------- | ----------------------------------- |
| when before onFlowStart hook fails, does that fail the whole flow?               | flow marked 🔴                      |
| when onFlowStart hook fails, does that skip the main body of the flow execution? | flow execution skipped              |
| when onFlowStart hook fails, does the onFlowComplete hook still run?             | onFlowComplete hook is still called |
| when the onFlowComplete hook fails, does the flow fail?                          | flow marked 🔴                      |

### onFlowStart / onFlowComplete in the subflows

If either **`onFlowStart`** or **`onFlowComplete`** hooks are implemented within a [subflow](../api-reference/commands/runflow.md), their commands will execute as expected. However, note that the execution start and end times will correspond to the subflow's duration, not the main flow's.



================================================
FILE: advanced/parameters-and-constants.md
================================================
# Parameters & Constants

### External parameters

There might be cases where you don't want to store certain values in a test file itself (i.e. user name, password, etc.). To solve that, you can pass parameters to Maestro:

```
maestro test -e USERNAME=user@example.com -e PASSWORD=123 file.yaml
```

And then refer to them in your flow using `${name}` notation:

```yaml
appId: your.app.id
---
- launchApp
- inputText: ${USERNAME}
- tapOn: Next
- inputText: ${PASSWORD}
```

In a similar fashion, parameters can be passed to `maestro cloud` command:

```
maestro cloud -e USERNAME=user@example.com PASSWORD=123 app.apk file.yaml
```

### Inline parameters

Constants can be declared at the flow file level, above the `---` marker:

```yaml
appId: your.app.id
env:
    USERNAME: user@example.com
    PASSWORD: 123
---
- inputText: ${USERNAME}
- inputText: ${PASSWORD}
```

Alternatively, they can be passed to a `runFlow` command:

```yaml
appId: your.app.id
---
- runFlow:
    file: subflow.yaml
    env:
      USERNAME: user@example.com
      PASSWORD: 123
```

{% content-ref url="nested-flows.md" %}
[nested-flows.md](nested-flows.md)
{% endcontent-ref %}

{% hint style="info" %}
Constants defined in a nested flow override parameters with the same name in the parent flow.
{% endhint %}

### Accessing variables from the shell

Maestro will automatically read environment variables from the shell prefixed by `MAESTRO_` and make them available in your Flows, assuming the environment variable is not manually defined in the Flow or passed as an env parameter.&#x20;

```
export MAESTRO_FOO=bar
```

If you define the variable `MAESTRO_FOO` as above, you can simply refer to it in your Flows when running `maestro test` or `maestro cloud` like a normal environment variable:

```
- tapOn: ${MAESTRO_FOO}
```

### Parameters and JavaScript

All `env` parameters are defined as JavaScript variables under the hood and can be accessed from the JavaScript code.

{% content-ref url="javascript/" %}
[javascript](javascript/)
{% endcontent-ref %}



================================================
FILE: advanced/specify-a-device.md
================================================
# Specify a Device

If you have multiple devices open, you can specify which device to run Maestro
on. To do this, you must first obtain the device identifier and then pass it to
Maestro.

### Obtain the device identifier

{% tabs %}
{% tab title="Android" %}
To list available Android devices, run the following command in your terminal:

```bash
adb devices
```

From the output, locate the device identifier for the device you want to use with Maestro.
{% endtab %}

{% tab title="iOS" %}
To list available iOS simulators, run the following command in your terminal:

```bash
xcrun simctl list devices booted
```

From the output, locate the device identifier for the device you want to use with Maestro.
{% endtab %}
{% endtabs %}

## Pass the device identifier to Maestro

When running any Maestro command that requires a device (e.g. `test` or `studio`), you must first pass the device identifier with the `--device` parameter before running the command.

For example, to run Maestro Studio on an Android device with identifier `emulator-5554` use the following command:

```css
maestro --device emulator-5554 studio
```

Similarly, to run `flow.yaml` on an iOS simulator with identifier
`5B6D77EF-2AE9-47D0-9A62-70A1ABBC5FA2` use the following command:

```
maestro --device 5B6D77EF-2AE9-47D0-9A62-70A1ABBC5FA2 test flow.yaml
```

## Run flows in parallel

Maestro can run tests in parallel, also known as "sharding".

{% embed url="https://youtu.be/VS1TqvZz398" %}

There are two sharding strategies available.

### --shard-all

To run tests in parallel, you can use the `--shard-all` parameter. This
parameter will run the same tests in parallel on available devices:

```
maestro test --shard-all 3 .maestro
```

### --shard-split

Let’s say you have 3 running devices and 9 tests, but now you want to split this
test suite into 3 chunks of tests and run them in parallel on connected devices:

```
maestro test --shard-split 3 .maestro
```

{% hint style="warning" %}
To run with `--shard-all 3` or `--shard-split`, you need to have 3 available
devices. If there are less, Maestro will print an error and request you to run
more devices.
{% endhint %}



================================================
FILE: advanced/testing-in-different-locales.md
================================================
# Test in different locales

It is possible to use `maestro start-device` command to create a new device with
a custom locale. This functionality enables an option to write and test Maestro
flows for different languages. The parameter `--device-locale` is a combination
of [ISO-639-1](https://en.wikipedia.org/wiki/List\_of\_ISO\_639-1\_codes) +
[ISO-3166-1](https://en.wikipedia.org/wiki/ISO\_3166-1), separated by an underscore
`_` symbol in between them.

Let's see some examples:

{% code title="Create a new iOS simulator with locale set to Italy (Italian)" %}
```console
maestro start-device \
  --platform ios \
  --device-locale it_IT
```
{% endcode %}

{% code title="Create a new Android emulator with locale set to France (French)" %}
```console
maestro start-device \
  --platform android \
  --device-locale fr_FR
```
{% endcode %}

Below you can find a full list of supported device locales per platform.

### Supported device locales on Android

| Language code | Language name    |
| ------------- | ---------------- |
| ar            | Arabic           |
| bg            | Bulgarian        |
| ca            | Catalan          |
| zh            | Chinese          |
| hr            | Croatian         |
| cs            | Czech            |
| da            | Danish           |
| nl            | Dutch            |
| en            | English          |
| fi            | Finnish          |
| fr            | French           |
| de            | German           |
| el            | Greek            |
| he            | Hebrew           |
| hi            | Hindi            |
| hu            | Hungarian        |
| id            | Indonesian       |
| it            | Italian          |
| ja            | Japanese         |
| ko            | Korean           |
| lv            | Latvian          |
| lt            | Lithuanian       |
| nb            | Norwegian-Bokmol |
| pl            | Polish           |
| pt            | Portuguese       |
| ro            | Romanian         |
| ru            | Russian          |
| sr            | Serbian          |
| sk            | Slovak           |
| sl            | Slovenian        |
| es            | Spanish          |
| sv            | Swedish          |
| tl            | Tagalog          |
| th            | Thai             |
| tr            | Turkish          |
| uk            | Ukrainian        |
| vi            | Vietnamese       |

| Country code | Country name   |
| ------------ | -------------- |
| AU           | Australia      |
| AT           | Austria        |
| BE           | Belgium        |
| BR           | Brazil         |
| GB           | Britain        |
| BG           | Bulgaria       |
| CA           | Canada         |
| HR           | Croatia        |
| CZ           | Czech Republic |
| DK           | Denmark        |
| EG           | Egypt          |
| FI           | Finland        |
| FR           | France         |
| DE           | Germany        |
| GR           | Greece         |
| HK           | Hong-Kong      |
| HU           | Hungary        |
| IN           | India          |
| ID           | Indonesia      |
| IE           | Ireland        |
| IL           | Israel         |
| IT           | Italy          |
| JP           | Japan          |
| KR           | Korea          |
| LV           | Latvia         |
| LI           | Liechtenstein  |
| LT           | Lithuania      |
| NL           | Netherlands    |
| NZ           | New Zealand    |
| NO           | Norway         |
| PH           | Philippines    |
| PL           | Poland         |
| PT           | Portugal       |
| CN           | PRC            |
| RO           | Romania        |
| RU           | Russia         |
| RS           | Serbia         |
| SG           | Singapore      |
| SK           | Slovakia       |
| SI           | Slovenia       |
| ES           | Spain          |
| SE           | Sweden         |
| CH           | Switzerland    |
| TW           | Taiwan         |
| TH           | Thailand       |
| TR           | Turkey         |
| UA           | Ukraine        |
| US           | USA            |
| VN           | Vietnam        |
| ZA           | Zimbabwe       |

### Supported device locales on iOS

| Locale code | Locale name             |
| ----------- | ----------------------- |
| en\_AU      | Australia (English)     |
| nl\_BE      | Belgium (Dutch)         |
| fr\_BE      | Belgium (French)        |
| ms\_BN      | Brunei Darussalam       |
| en\_CA      | Canada (English)        |
| fr\_CA      | Canada (French)         |
| cs\_CZ      | Czech Republic          |
| fi\_FI      | Finland                 |
| de\_DE      | Germany                 |
| el\_GR      | Greece                  |
| hu\_HU      | Hungary                 |
| hi\_IN      | India (Hindi)           |
| id\_ID      | Indonesia               |
| he\_IL      | Israel                  |
| it\_IT      | Italy                   |
| ja\_JP      | Japan                   |
| ms\_MY      | Malaysia                |
| nl\_NL      | Netherlands             |
| en\_NZ      | New Zealand             |
| nb\_NO      | Norway                  |
| tl\_PH      | Philippines             |
| pl\_PL      | Poland                  |
| zh\_CN      | PRC                     |
| ro\_RO      | Romania                 |
| ru\_RU      | Russia                  |
| en\_SG      | Singapore               |
| sk\_SK      | Slovakia                |
| ko\_KR      | Korea                   |
| sv\_SE      | Sweden                  |
| zh\_TW      | Taiwan                  |
| th\_TH      | Thailand                |
| tr\_TR      | Turkey                  |
| en\_GB      | UK (English)            |
| uk\_UA      | Ukraine                 |
| es\_US      | USA (Spanish)           |
| en\_US      | USA (English)           |
| vi\_VN      | Vietnam                 |
| pt-BR       | Brazil (Portuguese)     |
| zh-Hans     | China (Simplified)      |
| zh-Hant     | China (Traditional)     |
| zh-HK       | Hong Kong               |
| en-IN       | India (English)         |
| en-IE       | Ireland                 |
| es-419      | Latin America (Spanish) |
| es-MX       | Mexico (Spanish)        |
| en-ZA       | South Africa (English)  |
| es\_ES      | Spain                   |
| fr\_FR      | France                  |



================================================
FILE: advanced/wait.md
================================================
# Wait

{% hint style="warning" %}
By design, Maestro highly discourages a pattern of introducing artificial wait blocks as we believe that Maestro is already handling that reasonably well. Commands listed below should be used as a last resort in exceptional cases where a longer wait period is required (i.e. waiting for a video to finish)
{% endhint %}

If you need to wait for an element to become visible _within a reasonable time_ (i.e. 5-10 seconds), use assertions instead:

{% content-ref url="../api-reference/commands/assertvisible.md" %}
[assertvisible.md](../api-reference/commands/assertvisible.md)
{% endcontent-ref %}

{% content-ref url="../api-reference/commands/assertnotvisible.md" %}
[assertnotvisible.md](../api-reference/commands/assertnotvisible.md)
{% endcontent-ref %}



### extendedWaitUntil

Waits until an element becomes visible. More documentation can be found in the API reference:

{% content-ref url="../api-reference/commands/extendedwaituntil.md" %}
[extendedwaituntil.md](../api-reference/commands/extendedwaituntil.md)
{% endcontent-ref %}

### waitForAnimationToEnd

Waits until an ongoing animation/video is fully finished and screen becomes static. More information can be found in the API reference:

{% content-ref url="../api-reference/commands/waitforanimationtoend.md" %}
[waitforanimationtoend.md](../api-reference/commands/waitforanimationtoend.md)
{% endcontent-ref %}



================================================
FILE: advanced/javascript/README.md
================================================
# JavaScript

Maestro supports a minimal subset of vanilla JavaScript APIs with some purpose-built Maestro extensions. Though none of the functions that allow interaction with the OS are available (i.e. there is no access to the filesystem, no ability to require or import libraries), those scripts offer just enough functionality to write more sophisticated conditions, perform calculations or constructions, and to make HTTP requests.

{% hint style="warning" %}
Currently, Maestro by default uses the [Rhino](https://github.com/mozilla/rhino) JavaScript runtime to execute JavaScript, which has very limited modern JavaScript support. For a full list of API compatibility, please refer to [this compatibility table](https://mozilla.github.io/rhino/compat/engines.html).
{% endhint %}

{% hint style="info" %}
Maestro also supports an alternative JavaScript runtime – [GraalJS](https://github.com/oracle/graaljs). We intend to make GraalJS the default soon and then deprecate and remove Rhino. **We recommend everyone to opt-in to use GraalJS.**

**Learn more about** [**GraalJS support**](graaljs-support.md).
{% endhint %}



================================================
FILE: advanced/javascript/access-element-text.md
================================================
# Access element text

In order to access text of UI elements, use `copyTextFrom` [command](../../api-reference/commands/copytextfrom.md). The text can then be accessed via `maestro.copiedText` variable:

```
- copyTextFrom: My Field
- inputText: ${'Hello ' + maestro.copiedText}
```



================================================
FILE: advanced/javascript/graaljs-support.md
================================================
# GraalJS support

It is possible to use the [GraalJS](https://github.com/oracle/graaljs) runtime instead of [Rhino](https://github.com/mozilla/rhino) for JavaScript evaluation. GraalJS is fully ECMAScript 2022 compliant while Rhino only supports ECMAScript 5.

{% hint style="info" %}
Right now, Rhino is the default JavaScript engine, but we intend to make GraalJS the default soon and then deprecate and remove Rhino.

[This issue track the progress](https://github.com/mobile-dev-inc/maestro/issues/2049).
{% endhint %}

#### Enable GraalJS via flow config

{% hint style="warning" %}
This only has an effect if present in the top-level flow. It is ignored when included in any subflows.
{% endhint %}

```yaml
appId: com.example.app
jsEngine: graaljs
---
# The ?? operator is an example of an ES2020 feature and is not supported by Rhino
- inputText: ${null ?? 'foo'}
```

#### Enable GraalJS via environment variable

{% hint style="warning" %}
When [running in the cloud](../../cloud/run-maestro-tests-in-the-cloud.md), use the flow config above. The env var below is not supported in the cloud.
{% endhint %}

```bash
export MAESTRO_USE_GRAALJS=true
maestro test my-flow.yaml
```

### GraalJS behavior differences

There are some differences between the new `GraalJsEngine` and the current `RhinoJsEngine` implementation that are worth noting. All of the differences below and some others are documented and tested by the `GraalJsEngineTest` and `RhinoJsEngineTest` tests.

{% hint style="info" %}
**TL;DR** is that the variable scoping when using GraalJS is more consistent and understandable.
{% endhint %}

| Rhino JS                                                                                                                                                                                                                                                                                                                            | GraalJS                                                                                                                         |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| <ul><li>Can not reuse variable names across scripts within the same Flow</li></ul><ul><li>Can reuse variable names if redeclaration lives in a subflow</li></ul><ul><li>Can access variables declared earlier in the Flow in a separate script</li></ul><ul><li><code>output</code> variable is shared across all scripts</li></ul> | <ul><li>Variables are local to each script</li></ul><ul><li><code>output</code> variable is shared across all scripts</li></ul> |

**Some examples**

<table data-full-width="true"><thead><tr><th>Case</th><th width="363">Code sample</th><th>Rhino JS</th><th>GraalJS</th></tr></thead><tbody><tr><td>Redeclaring variables across scripts</td><td><pre class="language-yaml"><code class="lang-yaml">appId: com.example.example
---
- evalScript: ${const foo = null}
- evalScript: ${const foo = null}
</code></pre></td><td>❌ Variable redeclarations throw an error</td><td>✅ Variable names can be reused across scripts</td></tr><tr><td>Accessing variables across scripts</td><td><pre class="language-yaml"><code class="lang-yaml">appId: com.example.example
---
- evalScript: ${const name = 'joe'}
- evalScript: ${name === 'joe'}
</code></pre></td><td>✅ Variables are accessible across scripts</td><td>❌ Variables can't be accessed across scripts</td></tr><tr><td>Handling special characters</td><td><pre class="language-yaml"><code class="lang-yaml">appId: com.example.app
env:
  FOO: \
---
- tapOn: Username
- inputText: ${FOO}
</code></pre></td><td>❌ Single backslash causes an exception</td><td>✅ Single backslash and all other special chars are handled correctly</td></tr></tbody></table>



================================================
FILE: advanced/javascript/logging.md
================================================
# Logging

Maestro supports logging to the console via `console.log`.

{% hint style="info" %}
Logging with multiple arguments is not supported. Running `console.log('My variable is', variable)` will only output `My variable is`.
{% endhint %}

### Logging with `evalScript` command

If you want to log something inline you can use `evalScript` to output it to the
console without having to create a separate file:

```yaml
- evalScript: ${console.log('Hello from Javascript')}
```

{% content-ref url="../../api-reference/commands/evalscript.md" %}
[evalscript.md](../../api-reference/commands/evalscript.md)
{% endcontent-ref %}

### Logging in a separate JavaScript file

```yaml
- runScript: script.js
```

{% code title="script.js" %}
```javascript 
const myVar = 'foo';
console.log(myVar); // outputs 'foo'
console.log(`myVar is ${myVar}`) // outputs 'myVar is foo'
```
{% endcode %}

{% content-ref url="../../api-reference/commands/runscript.md" %}
[runscript.md](../../api-reference/commands/runscript.md)
{% endcontent-ref %}



================================================
FILE: advanced/javascript/make-http-s-requests.md
================================================
# Make HTTP requests

Maestro comes with its own JavaScript HTTP API

```javascript
// script.js
const response = http.get('https://example.com')

output.script.result = response.body
```

### JSON

Use `json()` function to parse JSON responses.

For example, assume that `https://example.com/jsonEndpoint` returns the following result:

```json
{
    "myField": {
        "mySubField": "Test value"
    }
}
```

`mySubField` could then be accessed in the following way:

```javascript
// script.js
const response = http.get('https://example.com/jsonEndpoint')

output.script.result = json(response.body).myField.mySubField
```

### POST request

To send body to a given endpoint, specify a `body` parameter:

```javascript
// script.js
const response = http.post('https://example.com/myEndpoint', {
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(
        {
            myField: "Payload"
        }
    )
})
```

Setting a `'Content-Type'` header might be required. See [Headers](make-http-s-requests.md#headers).

You can also send multipart form data by specyfying `multipartForm` parameter:

```javascript
// script.js
const response = http.post('https://example.com/myEndpoint', {
    multipartForm: {
      "uploadType": "import",
      "data": {
        "filePath": filePath,
        "mediaType": "text/csv"
      }
    },
})
```

In `multipartForm` you can include many fields. It is also possible to upload multiple files in one request by using objects with filePath property. `filePath` is required for the files. `mediaType` is optional.

> **ℹ️ Note** If you include both `body` and `multipartForm` in one request then `body` will be ignored.

### Headers

Headers can be provided in a `headers` parameter

```javascript
// script.js
const response = http.get('https://example.com', {
    headers: {
        Authorization: 'Bearer MyToken'
    }
})
```

### Other request types

The following request methods are provided out of the box:

* `http.get`
* `http.post`
* `http.put`
* `http.delete`

To send a request of any other HTTP method, use `http.request`

```javascript
// script.js
const response = http.request('https://example.com`, {
    method: "GET"   // or specify any other method, i.e. OPTION
})
```

### Response object

| Field Name | Value                                                                                                               |
| ---------- | ------------------------------------------------------------------------------------------------------------------- |
| `ok`       | `true` if request was successful, `false` otherwise                                                                 |
| `status`   | HTTP status code (i.e. `200`)                                                                                       |
| `body`     | String body of the response                                                                                         |
| `headers`  | response HTTP headers, where each header value is a string (or a comma-separated string in case of multiple values) |

### Example

Here's an example of using these utilities to perform a common test action, creating a user and populating it with data.

```javascript
const date = new Date();
const email = `test${date.getTime().toString()}@test.com`;
const password = 'test'

function createNewUser() {
  const url = 'https://my-api/signup'

  const signupResponse = http.post(url, {
    body: JSON.stringify({
      email: email,
      password: 'test'
    }),
    headers: {'Content-Type': 'application/json'}
  });

  const data = json(signupResponse.body);

  return {
    guid: data.guid,
    token: data.token
  }
}

function fillUserInfo() {
  const test_user = createNewUser()
  const url = `https://my-api/user/${test_user.guid}`

  http.request(url, {
    method: 'PATCH',
    body: JSON.stringify({
      age: '46',
      gender: 'female',
      country: 'Canada'
    }),
    headers: {
      'Content-Type': 'application/json', 
       Authorization: test_user.token,
      }
  })

  // return email and password for logging in to newly created account
  return {
    email: email,
    password: password
  }

}

output.test_user = fillUserInfo()
```

### Shared Functions

The output object in JavaScript can hold functions as well as values and JSON objects. You can use this to put all of your bespoke API calls into the output object, and call them from elsewhere in your flow.

_api.js:_

```javascript
function createUser(username) {
  return http.post("https://my-api/register", {
    body: {
      "username": username,
      "name": "Test User"
    }
  })
}


function getUserHistory(username) {
  return http.get("https://my-api/users/" + username + "/history")
}

output.api = {
  createUser,
  getUserHistory
}
```

_flow.yaml:_

```
appId: com.example
onFlowStart:
  - runScript: ./util/api.js
---
- launchApp
- evalScript: ${output.createUser('myTestUser')}
- tapOn: 'username'
- inputText: 'myTestUser'
```

### Additional Information

For test developers looking for additional information on the API, and the structure of objects, the Maestro implementation is a wrapper around okhttp3.



================================================
FILE: advanced/javascript/outputs.md
================================================
# Outputs

Though entirely optional, normally one would run a JavaScript code in order to produce a result to be used with other commands.

### output

The whole flow shares a single global `output` JavaScript object that can be modified to include results of a flow:

```javascript
// myScript.js
output.result = 'Hello World'
```

Where it can later be accessed either in the flow itself or in other scripts:

```yaml
- runScript: myScript.js
- inputText: ${output.result}
```

Note that in the example above, `result` is just an arbitrary name. It could be anything.

### Output Namespaces

Since `output` field is **global,** several scripts might clash with each other. Consider this example:

```javascript
// mySecondScript.js
output.result = 'Bye World'
```

The following flow will then print `Bye World`, overriding `Hello World` result from `myScript.js`

```yaml
- runScript: myScript.js
- runScript: mySecondScript.js
- inputText: ${output.result}   # inputs 'Bye World'
```

To avoid such conflicts, consider using _namespaces_ for your outputs:

```javascript
// myScript.js
output.myScript = {
    result: 'Hello World'
}
```

```javascript
// mySecondScript.js
output.mySecondScript = {
    result: 'Bye World'
}
```

Where a flow can then be explicit about which output it wants to use:

```yaml
- runScript: myScript.js
- runScript: mySecondScript.js
- inputText: ${output.myScript.result}   # inputs 'Hello World'
- inputText: ${output.mySecondScript.result}   # inputs 'Bye World'
```

{% hint style="info" %}
Note that you have full control over how to structure the outputs and are free to keep them as sophisticated or simple as you want. By the end of the day, `output` is just a JavaScript object.
{% endhint %}



================================================
FILE: advanced/javascript/run-javascript.md
================================================
# Run JavaScript

Maestro is not a JavaScript testing framework, but we recognize not everything
can (or should) be written in YAML. That's why we have JavaScript support.

There are several ways to run JavaScript, depending on your needs.

{% hint style="info %}
Right now, Rhino is the default JavaScript engine in Maestro, but we intend to
make GraalJS the default soon and then deprecate and remove Rhino. We recommend
everyone to opt-in to use GraalJS.

**Learn more about [GraalJS support](./graaljs-support.md)**.
{% endhint %}

## Inject

Everything within `${}` blocks is evaluated as JavaScript, allowing you to
insert dynamically computed values into any other Maestro command.

```yaml
appId: com.example
env:
  MY_NAME: John
---
- launchApp
- inputText: ${1 + 1}               # Inputs '2'
- inputText: ${'Hello ' + MY_NAME}  # Inputs 'Hello John'
- tapOn: ${MY_NAME}                 # Taps on element with text 'John'
```

## Run file

If you want to run a JavaScript file you can use the runScript command:

{% content-ref url="../../api-reference/commands/runscript.md" %}
[runscript.md](../../api-reference/commands/runscript.md)
{% endcontent-ref %}

### Passing parameters

`runScript` accepts `env` parameters, in the same way as `runFlow` does (see
[nested-flows.md](../nested-flows.md "mention")).

Passing a parameter:

```yaml
- runScript:
    file: script.js
    env:
       myParameter: Parameter
```

Reading a parameter in JavaScript:

```javascript
const readPassedParameter = myParameter;
console.log(readPassedParameter); // Outputs 'Parameter'
```

## Inline

For very simple computations (like the one above), creating a new file might be cumbersome. For this use case you can use the `evalScript` command:

{% content-ref url="../../api-reference/commands/evalscript.md" %}
[evalscript.md](../../api-reference/commands/evalscript.md)
{% endcontent-ref %}

## Inbuilt functions & properties

Whilst the JavaScript environment is limited, there are a few inbuilt things that can be used:

### object `maestro`

The `maestro` object contains the following properties:

| Field Name    | Value                    |
| ----------    | ------------------------ |
| `copiedText`  | Results of the [copyTextFrom](../../api-reference/commands/copytextfrom.md) command. See [Access element text](./access-element-text.md) |
| `platform`    | The platform the test is running on. Either `ios` or `android` |

The `maestro.platform` value is useful for conditional logic that differs
between Android and iOS. For example, you might want to handle location
permission differently:

```yaml
- runScript: setPermissionsVars.js
- tapOn: "Enable Location"
- assertVisible: ${output.locationPermissionAlert}
- tapOn: ${output.locationPermissionButton}
```

{% code title="setPermissionsVars.js" %}
```javascript
// setPermissionsVars.js
if (maestro.platform === 'ios') {
    output.locationPermissionAlert = "This app uses your location to show you information about your local environment"
    output.locationPermissionButton = "Allow"
}
if (maestro.platform === 'android') {
    output.locationPermissionAlert = "Allow access to this device's location?"
    output.locationPermissionButton = "While using the app"
}
```
{% endcode %}

### function `relativePoint`

The `relativePoint` function converts decimal values to string percentages,
which is the format that Maestro commands expect.

```yaml
- evalScript: ${output.specialPoint = relativePoint(0.13, 0.56)}
- tapOn:
    point: ${output.specialPoint} # Taps on the point '13%,56%'
```

### Others

The following inbuilt functions are documented in [Make HTTP requests](./make-http-s-requests.md):

* http.request
* http.get
* http.post
* http.put
* http.delete
* json



================================================
FILE: api-reference/common-commands-arguments.md
================================================
# Arguments common for all commands

Some arguments are common to all commands.

## Labels

Each Maestro command accepts an optional `label` attribute that lets you
customize the command's name:

```yaml
- tapOn:
    id: buy-now
    label: Tap on Buy Now button
    
- inputText:
    label: Input the company email
    text: maestro@mobile.dev

- swipe:
    direction: LEFT
    label: Swipe for onboarding
```

```
✅ Tap on Buy Now button
✅ Input the company email
✅ Swipe for onboarding
```

Setting a label can have an additional advantage of being able to remove
sensitive content from console output, for example this:

```
✅ Tap on "Password"
✅ Input text "mySecr3tPassw0rd!"
```

becomes:

```
✅ Tap on "Password"
✅ Enter the test user's password
```

{% hint style="warning" %}
The values will still appear in the logs of the run.
{% endhint %}

Labels are also a useful alternative to comments for contributors trying to
understand the intent of a particular step.

```yaml
- extendedWaitUntil:
    visible: Recommended Products
    timeout: 5000
    label: Wait for all personalized content to load
```

## Optional

Each Maestro command accepts an optional `optional` attribute that lets control
what should happen if the command fails.

```yaml
- launchApp: com.example.example
- assertVisible:
    text: Summer sale is here!
    optional: true
- tapOn: Sign up now!
```

If `optional` is set to `true`, the flow will continue executing even if the
command fails. The warning will be displayed:

```
✅ Launch app "com.example.example"
⚠️ Assert that "Summer sale is here!" is visible (warned)
✅ Tap on "Sign up now!"
```

The default value of `optional` for almost all commands is `false`, which means
that the flow will stop executing if any command fails. The only exception (at
least for now) are AI-powered commands, which have `optional` set to `true` by
default.

{% hint style="info" %}
Setting the `optional` attribute doesn't make sense on some commands, e.g.
`back` or `startRecording`. Nevertheless, it's still possible to set it, but it
won't have any effect.
{% endhint %}



================================================
FILE: api-reference/selectors.md
================================================
# Selectors

Commands that interact with a view (e.g `tapOn`, `assertVisible`,
`copyTextFrom`) require the view to be specified using using a _selector_.

There are many different selectors available:

```yaml
- tapOn: # or any other command that works with selectors
    text: 'Text'     # (optional) Finds element with text or accessibility text that matches the regular expression
    id: 'the_id'     # (optional) Finds element with accessibility identifier that matches the regular expression
    index: 0         # (optional) 0-based index of the view to select among those that match all other criteria
    point: 50%, 50%  # (optional) Relative position on screen. "50%, 50%" is the middle of screen
    point: 50, 75    # (optional) Exact coordinates on screen. x:50 y:50, in pixels
    width: 100       # (optional) Finds element of a given width
    height: 100      # (optional) Finds element of a given height
    tolerance: 10    # (optional) Tolerance to apply when comparing width and height
    enabled: true    # (optional) Searches for view with a given "enabled" state
    checked: true    # (optional) Searches for view with a given "checked" state
    focused: true    # (optional) Searches for view with a given "focused" state
    selected: true   # (optional) Searches for view with a given "selected" state
```

### Shorthand selector for text

If you want to use the `text` selector, you can use the following shorthand:

```yaml
- tapOn: 'Text' # or any other command that works with selectors
```

### Relative position selectors

Apart from the selectors mentioned above, Maestro is also able to select views
using their relative position (i.e. "below another view", or "contains child"):

```yaml
- tapOn: # or any other command that works with selectors
    below: View above that has this text       # matches a view *above* that has the given text
    above:
        id: view_below_id                      # matches a view *below* that has the given id
    leftOf: View to the right has this text
    rightOf: View to the left has this text
    containsChild: Text in a child view        # matches a view that has a *direct* child view with the given text
    childOf:                                   # matches a view that is a child of a view with id "buy-now"
        id: buy-now
    containsDescendants:                       # matches a view that has all the descendant views given below
        - id: title_id
          text: A descendant view has id "title_id" and this text
        - Another descendant view has this text
```

### Selecting one view among many similar

If you have multiple views matching the same selector (i.e. many views with text
`Hello`), use `index` parameter to specify which one to select exactly. For
example, the following command will pick the **3rd view** that has text `Hello`:

```yaml
- tapOn:
    text: Hello
    index: 2
```

### Using Regular Expressions

All text fields in Maestro element selectors are regular expressions. Whilst this document isn't intending to replace documentation on regular expressions (use your favourite search engine), here are a few examples of how it operates. In these examples, we've used `assertVisible`, but it's applicable to any text or id field.

#### Partial Matches

If you're on a screen with the sentence 'the quick brown fox jumps over the lazy log', and want to assert on two words in the sentence this won't work:

```yaml
- assertVisible: 'brown fox'
```

Because it's a regular expression, it needs to match the text of the entire element. This would work:

```yaml
- assertVisible: '.*brown fox.*'
```

#### Patterns

Regular Expressions are powerful. Imagine a screen that generates a random 6-digit number. Assuming you don't want to imbue your test with all of the material to generate an identical random number, you could assert that you're getting a number of the correct format like this:

```yaml
- assertVisible: '[0-9]{6}'
```

#### Escaping

One downside of regular expressions is that like any expression, there are control characters. If you're attempting to assert on the text 'Movies [NEW]', this won't work:

```yaml
- assertVisible: 'Movies [NEW]'
```

That's because square brackets have meaning in regular expressions. Instead, you'll need this:

```yaml
- assertVisible: 'Movies \[NEW\]'
```



================================================
FILE: api-reference/commands/README.md
================================================
# All commands



================================================
FILE: api-reference/commands/addmedia.md
================================================
# addMedia

Allows you to add media to the device's gallery for both Android and iOS, making them accessible for use in your application flow.

```yaml
- addMedia:
    - "./assets/foo.png" # path of media file in workspace
    - "./assets/foo.mp4"
```

Currently, maestro supports the following mime types for this command:

* PNG
* JPEG
* JPG
* GIF
*   MP4






================================================
FILE: api-reference/commands/assertnodefectswithai.md
================================================
# assertNoDefectsWithAI

{% hint style="warning" %}

This is an **experimental** feature powered by LLM technology. All feedback is
welcome.

{% endhint %}

```yaml
- assertNoDefectsWithAI
```

Takes a screenshot, uploads it to an LLM with a pre-made prompt, and asks the
model if it sees any common defects in the provided screenshot.

Common defects include text and UI elements being cut off, overlapping, or not
being centered within their containers.

### When to use?

We hope for `assertNoDefectsWithAI` to be used as a "smoke test" for parts of
your app that you want to ensure that "look right".

### Demo

{% embed url="https://youtu.be/tfawnGqEhF0" %}

### Output

Output is generated in HTML and JSON formats in the folder for the individual
test run:

```
~/.maestro
└── tests
    ├── 2024-08-20_213616
    │   ├── ai-(My first flow).json
    │   ├── ai-(My second flow).json
    │   ├── ai-report-(My first flow).html
    │   ├── ai-report-(My second flow).html
```

<figure><img src="../../.gitbook/assets/ai_demo.png" alt=""><figcaption></figcaption></figure>

### Configuration

{% content-ref url="../../api-reference/configuration/ai-configuration.md" %}
[ai-configuration.md](../../api-reference/configuration/ai-configuration.md)
{% endcontent-ref %}



================================================
FILE: api-reference/commands/assertnotvisible.md
================================================
# assertNotVisible

To assert whether an element is **not visible**, use the following command that takes the same parameters as `tapOn`

```yaml
- assertNotVisible:
    # Same exact parameters as tapOn
```

This command will wait for view to disappear if it is currently visible.

You are most likely going to be using the following properties, but please refer to the [Selectors](../selectors.md) page for an exhaustive list of all available selectors:

* `text` - text in a view
* `id` - id of a view
* `enabled` - `true` if view is enabled
* `checked` - `true` if view is checked
* `focused` - `true` if view has keyboard focus
* `selected` - `true` if view is selected

#### Examples

To check whether view with a text `My Button` is visible you can run the following command:

```yaml
- assertNotVisible: "My Button"
```

To check whether view with a text `My Button` that is **also** enabled is not visible you can run the following command:

```yaml
- assertNotVisible:
    text: "My Button"
    enabled: true
```

Such test will fail if _either_

* There is no button with such text
* There is a button but it is disabled

#### Related commands

{% content-ref url="assertvisible.md" %}
[assertvisible.md](assertvisible.md)
{% endcontent-ref %}

{% content-ref url="asserttrue.md" %}
[asserttrue.md](asserttrue.md)
{% endcontent-ref %}



================================================
FILE: api-reference/commands/asserttrue.md
================================================
# assertTrue

Asserts whether given value is either true, non-empty, or _truthy_ ([in JavaScript terms](https://developer.mozilla.org/en-US/docs/Glossary/Truthy)):

```yaml
- assertTrue: ${value}
```

This command is primarily designed to be used in combination with JavaScript
values. For example, you can assert that two views have the same text:

```yaml
- copyTextFrom: View A
- evalScript: ${output.viewA = maestro.copiedText}
- copyTextFrom: View B
- assertTrue: ${output.viewA == maestro.copiedText}
```

You can also use it to immediately fail the test:

```yaml
- assertTrue:
    condition: ${false}
    label: This will always fail
```


#### Related commands

{% content-ref url="assertvisible.md" %}
[assertvisible.md](assertvisible.md)
{% endcontent-ref %}

{% content-ref url="assertnotvisible.md" %}
[assertnotvisible.md](assertnotvisible.md)
{% endcontent-ref %}



================================================
FILE: api-reference/commands/assertvisible.md
================================================
# assertVisible

To assert whether an element is **visible**, use the following command that takes the same parameters as `tapOn`

```yaml
- assertVisible:
    # Same exact parameters as in tapOn or any other command that uses selectors
```

This command will wait for view to appear if it is not visible yet.

You are most likely going to be using the following properties, but please refer to the [Selectors](../selectors.md) page for an exhaustive list of all available selectors:

* `text` - text in a view
* `id` - id of a view
* `enabled` - `true` if view is enabled
* `checked` - `true` if view is checked
* `focused` - `true` if view has keyboard focus
* `selected` - `true` if view is selected

#### Examples

To check whether view with a text `My Button` is visible you can run the following command:

```yaml
- assertVisible: "My Button"
```

To check whether view with a text `My Button` is visible **and** enabled you can run the following command:

```yaml
- assertVisible:
    text: "My Button"
    enabled: true
```

Such test will fail if _either_

* There is no button with such text
* There is a button but it is disabled

#### Related commands

{% content-ref url="assertnotvisible.md" %}
[assertnotvisible.md](assertnotvisible.md)
{% endcontent-ref %}

{% content-ref url="asserttrue.md" %}
[asserttrue.md](asserttrue.md)
{% endcontent-ref %}



================================================
FILE: api-reference/commands/assertwithai.md
================================================
# assertWithAI

{% hint style="warning" %}

This is an **experimental** feature powered by LLM technology. All feedback is
welcome.

{% endhint %}

```yaml
- assertWithAI:
    assertion: Login and password text fields are visible.
```

Takes a screenshot, uploads it to an LLM with a pre-made prompt combined with
`assertion`, and asks the model if assertion is true.

### When to use?

We hope for `assertWithAI` to be useful when it's hard (or even impossible) to
write the assertion using default assertion commands.

Asserting the presence of a two-factor authentication prompt is a good example.

<figure>
<img src="../.gitbook/assets/uber_2fa.png" alt="">
<figcaption></figcaption>
</figure>

```yaml
- assertWithAI:
    assertion: A two-factor authentication prompt, with space for 6 digits, is visible.
```

### Demo

{% embed url="https://youtu.be/tfawnGqEhF0" %}

### Output

Output is generated in HTML and JSON formats in the folder for the individual
test run:

```
~/.maestro
└── tests
    ├── 2024-08-20_213616
    │   ├── ai-(My first flow).json
    │   ├── ai-(My second flow).json
    │   ├── ai-report-(My first flow).html
    │   ├── ai-report-(My second flow).html
```

<figure><img src="../../.gitbook/assets/ai_demo.png" alt=""><figcaption></figcaption></figure>

### Configuration

{% content-ref url="../../api-reference/configuration/ai-configuration.md" %}
[ai-configuration.md](../../api-reference/configuration/ai-configuration.md)
{% endcontent-ref %}



================================================
FILE: api-reference/commands/back.md
================================================
# back

The following command navigates user to the previous screen (Android-only at the moment)

```
- back
```



================================================
FILE: api-reference/commands/clearkeychain.md
================================================
# clearKeychain

Clears the **entire** iOS keychain (not applicable on Android):

```
- clearKeychain
```



================================================
FILE: api-reference/commands/clearstate.md
================================================
# clearState

Clears the application state:

```yaml
- clearState            # clears the state of the current app
- clearState: app.id    # clears the state of an arbitrary app
```

#### What is being cleared?

{% tabs %}
{% tab title="Android" %}
The outcome of the command is identical to:

```
adb shell pm clear {package name}
```

That is removing all app-related data from the device (shared preferences, databases, accounts, etc.)
{% endtab %}

{% tab title="iOS" %}
The command is removing the contents of the application's data folder. An equivalent `idb` command would be:

```
idb file rm --application {bundle id}/
```

[It's also possible to use `xcrun simctl` for that.](https://stackoverflow.com/a/56746729/7009800)
{% endtab %}
{% endtabs %}



================================================
FILE: api-reference/commands/copytextfrom.md
================================================
# copyTextFrom

You can copy text from an element and save it in-memory, to paste later. To find the element you wish to copy text from you can use Selectors. For a full list of what selectors are available, please refer to the [Selectors](../selectors.md) page.

### Usage Example

Copy text from an element and paste it into a search field:

```yaml
appId: com.example.app
---
- launchApp
- copyTextFrom:
    id: "someId"
- tapOn:
    id: "searchFieldId"
- pasteText
```

The copied text can also be access in JavaScript using the `maestro.copiedText`
property:

```
appId: com.example.app
---
- launchApp
- copyTextFrom:
    id: "someId"
- tapOn:
    id: "searchFieldId"
- inputText: ${'Pasted using JavaScript: ' + maestro.copiedText}
```



================================================
FILE: api-reference/commands/doubletapon.md
================================================
# doubleTapOn

It will double tap on a selected element or point.&#x20;

```yaml
- doubleTapOn: "Button"
```

Accepts the same element selectors as tapOn

```yaml
- doubleTapOn:
    id: "someId" # or any other selector
    delay: 100 # (optional) Delay between taps. Default, 100ms
```

### Example

```
appId: com.other.app
---
- launchApp
- doubleTapOn:
    id: buttonId
```



================================================
FILE: api-reference/commands/erasetext.md
================================================
# eraseText

The  `eraseText` command removes characters from the currently selected text field (if any) and can be used as such:

```yaml
- eraseText # Removes up to 50 characters (default)
```

If you need to remove more characters, you can specify a number explicitly:

```yaml
- eraseText: 100    # Removes up to 100 characters
```

_Note: This is for searches looking for clearText._

***

{% hint style="warning" %}
**Flakiness on iOS**
{% endhint %}

We have seen cases where `eraseText` can be flaky on iOS. The maestro team is aware of that and is working on it. In the meantime, you can use the following commands to workaround the flakiness of the command:

```
- longPressOn: "<input text id>"
- tapOn: 'Select All'
- eraseText
```



================================================
FILE: api-reference/commands/evalscript.md
================================================
# evalScript

For more information regarding JavaScript, please refer to the Javascript section:

{% content-ref url="../../advanced/javascript/" %}
[javascript](../../advanced/javascript/)
{% endcontent-ref %}

For very simple computations (like the one above), creating a new file might be cumbersome. `evalScript` allows you to specify JavaScript directly in your Maestro flow.

```yaml
appId: com.example
env:
    MY_NAME: John
---
- launchApp
- evalScript: ${output.myFlow = MY_NAME.toUpperCase()}
- inputText: ${output.myFlow}
```



================================================
FILE: api-reference/commands/extendedwaituntil.md
================================================
# extendedWaitUntil

Waits until an element becomes visible. Fails if the element is not visible after the timeout expires. This command will complete as soon as element becomes visible and is not going to wait for timeout to expire.&#x20;

For an exhaustive list of selectors that can be used, please refer to the [Selectors](../selectors.md) page.

Example usage:

```yaml
- extendedWaitUntil:
    visible: "My text that should be visible" # or any other selector
    timeout: 10000      # Timeout in milliseconds
```

Similarly, it can wait until an element disappears:

```yaml
- extendedWaitUntil:
    notVisible: 
        id: "elementId" # or any other selector
    timeout: 10000
```

#### See also

{% content-ref url="../../advanced/wait.md" %}
[wait.md](../../advanced/wait.md)
{% endcontent-ref %}



================================================
FILE: api-reference/commands/extracttextwithai.md
================================================
# extractTextWithAI

{% hint style="warning" %}
This is an **experimental** feature powered by LLM technology. All feedback is welcome.
{% endhint %}

```yaml
- extractTextWithAI: CAPTCHA value
- inputText: ${aiOutput}
```

Takes a screenshot and tries to extract text value from the screen using LLM. Output is then written into `aiOutput` variable.

The name of the variable is also configurable:

```yaml
- extractTextWithAI:
    query: 'CAPTCHA value'
    outputVariable: 'theCaptchaValue'
```

For AI commands to work, AI must be configured first:

{% content-ref url="../configuration/ai-configuration.md" %}
[ai-configuration.md](../configuration/ai-configuration.md)
{% endcontent-ref %}

### When to use?

`extractTextWithAI` could be a good fit when:

* View ID or content is not known beforehand
  * Search results
* Information on the screen is presented as an image
  * Promotional banners with embedded text
  * Captcha

{% hint style="info" %}
`extractTextWithAI` is not intended to be a replacement for conventional element selectors (such as used with `tapOn`). When possible, prefer to use stable IDs or text values.
{% endhint %}

### Examples

#### Amazon Search Results

Amazon reports its search results without any distinct IDs assigned to each item. We also don't know what will show up in the results beforehand. To work around this problem we can use AI to hint us what is the label of the first product item on this page and then tap on it:

```yaml
- extractTextWithAI: Title of the first item on this page
- tapOn: ${aiOutput}
```

<figure><img src="../../.gitbook/assets/image (4) (1).png" alt=""><figcaption></figcaption></figure>

### Configuration

{% content-ref url="../configuration/ai-configuration.md" %}
[ai-configuration.md](../configuration/ai-configuration.md)
{% endcontent-ref %}








================================================
FILE: api-reference/commands/hidekeyboard.md
================================================
# hideKeyboard

### hideKeyboard

To hide the software keyboard, use `hideKeyboard` command:

```yaml
- hideKeyboard
```

{% hint style="warning" %}
On iOS, hideKeyboard can be flaky. [Read more here](../../troubleshooting/known-issues.md#ios-hidekeyboard-flaky).
{% endhint %}



================================================
FILE: api-reference/commands/inputtext.md
================================================
# inputText

Inputs text (regardless of whether any text field is currently focused or not)

```yaml
- inputText: "Hello World"
```

{% hint style="warning" %}
Unfortunately unicode characters are not supported yet in Android platform. Follow the [GitHub issue](https://github.com/mobile-dev-inc/maestro/issues/146) for status updates.
{% endhint %}

### Input random text

There are several convenience methods for entering a random text input:

```yaml
- inputRandomEmail       # Enters a random Email address
- inputRandomPersonName  # Enters a random person name
- inputRandomNumber      # Enters a random integer number
- inputRandomText        # Enters random unstructured text
```

#### Length

You can pass length as argument for `Number` and `Text`

```yaml
- inputRandomNumber:
    length: 10  #(default: 8)
- inputRandomText:
    length: 10  #(default: 8)
```



================================================
FILE: api-reference/commands/killapp.md
================================================
# killApp

The `killApp` command kills the app on Android. On iOS and Web, it's just an
alias for `stopApp`.

```yaml
- killApp
```

Killing the app on Android triggers a **System-initiated Process Death**. It is
the equivalent of calling:

```console
adb shell am kill {package name}
```

Here is an example how to fully reproduce a System-initiated Process Death:

{% code title="trigger-process-death.yaml" %}
```yaml
appId: com.example
---
- pressKey: Home # Puts the app into the background
- killApp # Kills the app (adb shell am kill)
- launchApp: # Relaunches the app
    stopApp: false # Without adb shell am stop
```
{% endcode %}

It is advised to use this set of commands as a subFlow (e.g.
`trigger-process-death.yaml`) and re-use it via `runFlow` in every other test,
to re-check the data of the screen under test after the System-initiated Process
Death:

```yaml
appId: com.example
---
- launchApp
- tapOn:
    id: "com.example:id/enter_name"
- inputText: "John Doe"
- tapOn:
    id: "com.example:id/next"
- assertVisible:
    id: "com.example:id/show_name"
    text: "Name = John Doe"
    enabled: true
- runFlow: trigger-process-death.yaml
- assertVisible:
    id: "com.example:id/show_name"
    text: "Name = John Doe"
    label: "Asserts that \"Name = John Doe\" meaning the screen kept its data after System-initiated Process Death"
    enabled: true
- stopApp
```



================================================
FILE: api-reference/commands/launchapp.md
================================================
# launchApp



To launch the app under test, simply write:

```
- launchApp
```

To launch an arbitrary app with a given id (package name on Android, bundle id on iOS), do:

```yaml
- launchApp: appId
```

If you need to clear the app state before launching the app, specify a `clearState` flag

```yaml
- launchApp:
    appId: "com.example.app"
    clearState: true
    clearKeychain: true   # optional: clear *entire* iOS keychain
    stopApp: false # optional (true by default): stop the app before launching it
    permissions: { all: deny } # optional: by default all permissions are allowed,
                               # even if clearState: true is passed
```

If you want to test with a permission with a specific value, specify a permissions argument

```yaml
- launchApp:
    permissions:
        notifications: unset # notification permission is unset
        android.permission.ACCESS_FINE_LOCATION: deny # Android fine location permission is denied
```

### Launch Arguments

You can send launch arguments while launching the app for both iOS and Android.&#x20;

#### Sending launch arguments

Arguments allow sending **String**, **Boolean**, **Double,** and **Integer**. All other data types are by default passed as a String.

```yaml
- launchApp:
    appId: "com.example.app"
    arguments: 
       foo: "This is a string"
       isFooEnabled: false
       fooValue: 3.24
       fooInt: 3
```

#### Receiving arguments on Android

```kotlin
intent.extras?.getBoolean("isFooEnabled")?.let {
    // Do something with isFooEnabled
}

intent.extras?.getString("foo")?.let {
    // Do something with foo
}
```

#### Receiving arguments on iOS

```swift
if ProcessInfo.processInfo.arguments.contains("isFooEnabled") {
    // Do something with isFooEnabled
}

// By default all the values received here would be string
let standardDefaultsDict = UserDefaults.standard.dictionaryRepresentation()
let foo = (standardDefaultsDict["foo"] as? String) ?? "defaultValue"
```

#### Receiving arguments in React Native

```typescript
import { LaunchArguments } from 'react-native-launch-arguments'

export const isFooEnabled = () => {
  try {
    const foo = LaunchArguments.value().isFooEnabled
    return !!foo
  } catch (e) {
    return false
  }
}
```

#### Receiving arguments in Flutter

```dart
import 'package:flutter_launch_arguments/flutter_launch_arguments.dart';

Future<void> getArguments() async {
  final fla = FlutterLaunchArguments();

  final foo = await fla.getString('foo');
  final isFooEnabled = await fla.getBool('isFooEnabled');
  final fooValue = await fla.getDouble('fooValue');
  final fooInt = await fla.getInt('fooInt');
}
```


================================================
FILE: api-reference/commands/longpresson.md
================================================
# longPressOn

Like tapOn, but for longer presses. See the [tapOn](tapon.md#long-press) docs for examples.



================================================
FILE: api-reference/commands/openlink.md
================================================
# openLink

To open a link on a device (i.e. a deep link):

```yaml
- openLink: https://example.com
```

### Auto verification of your Android Apps&#x20;

If your app shows a disambiguation dialog along with other apps that can open the web link:

&#x20;![](../../.gitbook/assets/app-disambiguation\_2x.png)

You can auto-verify the web link to be opened by your app with `autoVerify` attribute:

```yaml
- openLink: 
    link: https://example.com
    autoVerify: true
```

Beyond Android version 12, web links are by default opened in the web browser. It is possible for maestro to also auto-accept agreements of Google chrome if shown with the same `autoVerify` flag.

### Opening web links in the browser for Android

It is possible with maestro to force open web links with the web browser:

```yaml
- openLink: 
    link: https://example.com
    browser: true
```



================================================
FILE: api-reference/commands/pastetext.md
================================================
# pasteText

Paste any text copied with [copyTextFrom](copytextfrom.md) into the currently
focused field.

{% hint style="info" %}
Make sure your text field is in focus before using this command.
{% endhint %}

```yaml
- pasteText
```

### Usage Example

Copy text from an element and paste it into a search field:

```yaml
appId: com.example.app
---
- launchApp
- copyTextFrom:
    id: "someId"
- tapOn:
    id: "searchFieldId"
- pasteText
```



================================================
FILE: api-reference/commands/presskey.md
================================================
# pressKey

`pressKey` command allows you to press a set of special keys:

* `home` - home button
* `lock` - button to lock the device screen
* `enter` - enter button
* `backspace` - backspace button
* `volume up` and `volume down` - control the volume
* `back` - back button (Android only)
* `power` - power button (Android only)
* `tab` - tab button (Android only)&#x20;

```yaml
- pressKey: Enter
```

#### Android TV

Some of the controls are specific to Android TV Remote:

* `Remote Dpad Up`
* `Remote Dpad Down`
* `Remote Dpad Left`
* `Remote Dpad Right`
* `Remote Dpad Center`
* `Remote Media Play Pause`
* `Remote Media Stop`
* `Remote Media Next`
* `Remote Media Previous`
* `Remote Media Rewind`
* `Remote Media Fast Forward`
* `Remote System Navigation Up`
* `Remote System Navigation Down`
* `Remote Button A`
* `Remote Button B`
* `Remote Menu`
* `TV Input`
* `TV Input HDMI 1`
* `TV Input HDMI 2`
* `TV Input HDMI 3`



================================================
FILE: api-reference/commands/repeat.md
================================================
# repeat

A command to repeat a set commands until a condition is met.

#### Repeat N times

Repeats set of commands N times

```yaml
- repeat:
    times: 3
    commands:
      - tapOn: Button
      - scroll
```

#### Repeat-while

Repeat set of commands until a condition is satisfied.

```yaml
- repeat:
    while:
      notVisible: "ValueX"
    commands:
      - tapOn: Button
```

A condition can also be a JavaScript expression:

```yaml
- evalScript: ${output.counter = 0}
- repeat:
    while:
      true: ${output.counter < 3}
    commands:
      - tapOn: Button
      - evalScript: ${output.counter = output.counter + 1}
```

To learn more about conditions, see the following section:

{% content-ref url="../../advanced/conditions.md" %}
[conditions.md](../../advanced/conditions.md)
{% endcontent-ref %}

{% hint style="info" %}
If you need to, you can specify both a count and a condition, for example repeating a set of commands whilst an element isn't visible, up to a maximum count of 10 times
{% endhint %}



================================================
FILE: api-reference/commands/retry.md
================================================
# retry

Some flaky behaviour is expected or beyond an app's control. For those situations, it can be useful having a small controlled loop that will retry one or more commands a limited number of times.

```yaml
- retry:
    maxRetries: 3
    commands:
      - tapOn:
          id: 'button-that-might-not-be-here-yet'
```

## Parameters

`maxRetries` is an integer indicating the number of times to attempt the flow. Minimum 0, maximum 3. Defaults to 1 retry attempt.

`commands` is a list of commands to run. This, or `file`, must be provided.

`file` is a reference to another flow to attempt. This, or `commands`, must be be provided (but not both).

Like other commands, this accepts the default parameters, such as `label`, `optional` and `env`.



================================================
FILE: api-reference/commands/runflow.md
================================================
# runFlow

If you'd like to avoid duplication of code or otherwise modularize your Flow files, you can use the `runFlow` command to run commands from another file.

### runFlow

Runs a flow from a specified file:

```yaml
- runFlow: anotherFlow.yaml
```

#### Example

Let's say you have a login sequence that you'd like to reuse across multiple flows. You can write the login commands in a separate file and run those steps from another Flow:

{% tabs %}
{% tab title="Login.yaml" %}
```yaml
appId: com.example.app
---
- launchApp
- tapOn: Username
- inputText: Test User
- tapOn: Password
- inputText: Test Password
- tapOn: Login
```
{% endtab %}

{% tab title="Profile.yaml" %}
```yaml
appId: com.example.app
---
- runFlow: Login.yaml # <-- Run commands from "Login.yaml"
- tapOn: Profile
- assertVisible: "Name: Test User"
```
{% endtab %}

{% tab title="Settings.yaml" %}
```yaml
appId: com.example.app
---
- runFlow: Login.yaml # <-- Run commands from "Login.yaml"
- tapOn: Settings
- assertVisible: "Switch to dark mode"
```
{% endtab %}
{% endtabs %}

#### Arguments

`runFlow` command can accepts arguments that will be passed to subflow, the same way as with `-e` or `env` block in the flow itself (see [Parameters & Constants](../../advanced/parameters-and-constants.md)):

```yaml
- runFlow: 
    file: anotherFlow.yaml
    env:
      MY_PARAMETER: "123"
```

#### Inline flows

If you would like to use `runFlow` without extracting the commands into a separate flow file, you can run your commands inline like this:

```yaml
- runFlow:
    env:
      INNER_ENV: Inner Parameter
    commands:
      - inputText: ${INNER_ENV}
```



{% hint style="warning" %}
Remember that when running in the cloud and requiring another file, you must specify a folder on the command line not just the flow file, e.g. `maestro cloud myApp.apk ./myTestsFolder` else Maestro won't have the files required to run your tests, and you'll receive a 'Failed to parse file' error.
{% endhint %}



================================================
FILE: api-reference/commands/runscript.md
================================================
# runScript

For more information regarding JavaScript, please refer to the Javascript section:

{% content-ref url="../../advanced/javascript/" %}
[javascript](../../advanced/javascript/)
{% endcontent-ref %}

`runScript` command runs a provided JavaScript file.

```yaml
appId: com.example
env:
    MY_NAME: John
---
- launchApp
- runScript: myScript.js
- inputText: ${output.myFlow}
```

A script would typically perform some action and set an output value that could be accessed later. See [outputs.md](../../advanced/javascript/outputs.md "mention") for more information.

```javascript
var uppercaseName = MY_NAME.toUpperCase()

output.myFlow = uppercaseName   // returns 'JOHN'
```

{% hint style="info" %}
You can directly access `env` parameters from within JavaScript. See [parameters-and-constants.md](../../advanced/parameters-and-constants.md "mention") for more information.
{% endhint %}

#### Passing parameters

`runScript` accepts `env` parameters, in the same way as `runFlow` does (see [nested-flows.md](../../advanced/nested-flows.md "mention")).

```javascript
- runScript:
    file: script.js
    env:
       myParameter: 'Parameter'
```

#### Running conditionally

You can use conditionals to run a JavaScript file when some condition is true. For more information, please refer to the [conditionals](../../advanced/conditions.md) documentation.

#### Console logging&#x20;

Console logging is supported from the javascript files provided in `runScript` command. Logs from javascript are redirected to the console when using Maestro CLI.&#x20;

<figure><img src="../../.gitbook/assets/image (2) (1).png" alt=""><figcaption></figcaption></figure>



{% hint style="warning" %}
Remember that when running in the cloud and requiring another file, you must specify a folder on the command line not just the flow file, e.g. `maestro cloud myApp.apk ./myTestsFolder` else Maestro won't have the files required to run your tests, and you'll receive a 'Failed to parse file' error.
{% endhint %}



================================================
FILE: api-reference/commands/scroll.md
================================================
# scroll

To do a simple vertical scroll you can simply run the following command:

```yaml
- scroll
```



================================================
FILE: api-reference/commands/scrolluntilvisible.md
================================================
# scrollUntilVisible

To scroll towards a direction until an element becomes visible in the view hierarchy, use the following command:

<pre class="language-yaml"><code class="lang-yaml"><strong>- scrollUntilVisible:
</strong>    element:
      id: "viewId" # or any other selector
    direction: DOWN # DOWN|UP|LEFT|RIGHT (optional, default: DOWN)
    timeout: 50000 # (optional, default: 20000) ms
    speed: 40 # 0-100 (optional, default: 40) Scroll speed. Higher values scroll faster.
    visibilityPercentage: 100 # 0-100 (optional, default: 100) Percentage of element visible in viewport
    centerElement: false # true|false (optional, default: false)
</code></pre>

Please refer to the [Selectors](../selectors.md) page for a full list of supported selectors.

### Direction

The scroll will move towards the direction specified `DOWN|UP|LEFT|RIGHT`. For example, if `DOWN` is specified then it will start scrolling towards the bottom of the screen.



### Timeout

The timeout (in miliseconds) defines how long it should scroll and look for the specified element. The test fails if the timeout ends before the specified element is visible. If the element is visible, the test will move on with the next command / step.



### Center Element

If enabled, it will attempt to stop when the element is closer to the screen center.&#x20;

In case it's not possible to bring the element to the center (i.e it's the last element in the list), it will stop scrolling after few attempts.

```yaml
- scrollUntilVisible:
    centerElement: true
    element:
      text: "Item 6"
```



### Visibility Percentage

By default an element will be considered visible if it is fully displayed in the viewport. You can adjust that threshold by modifying `visibilityPercentage`.



### Example

If you want to scroll until the text "My text" is visible you can run the following command:

```yaml
- scrollUntilVisible:
    element: "My text" # or any other selector
    direction: DOWN
```

If we want to scroll towards the bottom until a view with id `com.example.resource.some_view_id` becomes visible, you can use the `id` selector like this:

```yaml
- scrollUntilVisible:
    element:
      id: ".*some_view_id" # or any other selector
    direction: DOWN
```




================================================
FILE: api-reference/commands/setairplanemode.md
================================================
# setAirplaneMode

`setAirplaneMode` allows controlling the airplane mode of the device:

```yaml
- setAirplaneMode: enabled
- setAirplaneMode: disabled
```

If you want to toggle the airplane mode, see [toggleAirplaneMode](./toggleairplanemode.md).

{% hint style="info" %}
iOS simulators don't have an airplane mode, this is only available on Android.
{% endhint %}



================================================
FILE: api-reference/commands/setlocation.md
================================================
# setLocation

`setLocation` command applies a mock geolocation to the device:

```
- setLocation:
    latitude: 52.3599976
    longitude: 4.8830301
```

{% hint style="warning" %}
Note that this only updates the co-ordinate location of the emulator/simulator. When [running in the cloud](../../cloud/run-maestro-tests-in-the-cloud.md), if your app relies on IP location, this will still resolve to US.
{% endhint %}

{% hint style="info" %}
Note that for Android, this only works on API level 31 or above. Support for lower levels is coming soon!
{% endhint %}



================================================
FILE: api-reference/commands/startrecording.md
================================================
# startRecording

To start a screen recording, add the `- startRecording: name` command to your Flow like this:

```yaml
appId: yourAppId
---
- launchApp
- startRecording: recording
...
- stopRecording
...
```

Your recording will then be available in the same directory as the test flow.



To give a startRecording a label, or mark as optional, you can use the long form of the command:

```
- startRecording:
    path: 'logging_in'
    label: 'Begin collecting test evidence'
    optional: true
    
```



To stop a recording in progress, use the `stopRecording` command.

{% content-ref url="stoprecording.md" %}
[stoprecording.md](stoprecording.md)
{% endcontent-ref %}




================================================
FILE: api-reference/commands/stopapp.md
================================================
# stopApp

Stops current application if it is running:

```yaml
- stopApp
```

You can also specify app id of the app to be stopped:

```yaml
- stopApp: appId
```



================================================
FILE: api-reference/commands/stoprecording.md
================================================
# stopRecording

You can stop a running screen recording using `- stopRecording`.

```yaml
appId: yourAppId
---
- launchApp
- startRecording: name
...
- stopRecording
```

{% content-ref url="startrecording.md" %}
[startrecording.md](startrecording.md)
{% endcontent-ref %}



================================================
FILE: api-reference/commands/swipe.md
================================================
# swipe

To have control over the swipe gesture, you have the following choices:

#### **Relative Swipe Using Percentages**

You can specify start and end coordinates in percentages to make the swipe gesture consistent across different screen dimensions:

```yaml
- swipe:  
    start: 90%, 50% # From (90% of width, 50% of height)
    end: 10%, 50% # To (10% of width, 50% of height)
```

#### **Swiping Directions**&#x20;

Swiping in RIGHT, LEFT, UP, or DOWN directions:

1. **LEFT**: From the right to the left of the screen.
2. **RIGHT**: From the left to the right of the screen.
3. **UP**: From the middle of the device to the top of the device.
4. **DOWN**: From the top of the device to the bottom of the device.

Example:

```yaml
- swipe:              # This command swipes in the left direction from the middle of the device. 
    direction: LEFT
```

Relative start and end coordinates for directional swipe are configured as follows:

<table><thead><tr><th width="156" align="center">Direction</th><th width="286.3333333333333" align="center">Start (x%, y%)</th><th align="center">End (x%, y%)</th></tr></thead><tbody><tr><td align="center">LEFT</td><td align="center">(90% of width, 50% of height)</td><td align="center">(10% of width, 50% of height)</td></tr><tr><td align="center">RIGHT</td><td align="center">(10% of width, 50% of height)</td><td align="center">(90% of width, 50% of height)</td></tr><tr><td align="center">DOWN </td><td align="center">(50% of width, 20% of height)</td><td align="center">(50% of width, 90% of height)</td></tr><tr><td align="center">UP</td><td align="center">(50% of width, 50% of height)</td><td align="center">(50% of width, 10% of height)</td></tr></tbody></table>

A common use case for this is to swipe the onboarding pages.

#### **Swiping elements**

You can also specify elements as a starting point for swipe commands. It will swipe from the middle of the element in the direction you specify. Example:

```yaml
- swipe:
   from: 
     id: "feeditem_identifier" # From (x, y) center of element
   direction: UP # To (50% of width, 10% of height)
    
```

Note that you can use any selector here to target an element to swipe from. Please refer to the [Selectors](../selectors.md) page for a full list of available selectors.

#### **Swiping Coordinates**

You can also specify start and end points for the swipe to have more control:

```yaml
- swipe:                 # This command swipes from point (x:100, y:200) to point (x: 300, y:400). Units are in pixels
    start: 100, 200
    end: 300, 400
```

{% hint style="warning" %}
It is not recommended to use absolute coordinates when swiping as this might mean that your test won't work on a device with a different screen configuration.
{% endhint %}

#### Swiping speed

To control swiping speed you can use duration in the swipe command. The more the duration slower the swipe. By default, the swipe command uses 400 milliseconds. To configure speed you can use:

```yaml
- swipe:
    direction: LEFT
    duration: 2000      # Values are in ms.
```




================================================
FILE: api-reference/commands/takescreenshot.md
================================================
# takeScreenshot

`takeScreenshot` saves a screenshot as a PNG file in the Maestro workspace.

```yaml
- takeScreenshot:
    path: LoginScreen # screenshot will be stored as LoginScreen.png
```

It can also be written in the short form:

```yaml
- takeScreenshot: MainScreen # screenshot will be stored as MainScreen.png
```

### Path

The path is relative to the Maestro workspace directory, not to the flow file.



================================================
FILE: api-reference/commands/tapon.md
================================================
# tapOn

In order to tap on a view with the text "My text" you can use the shorthand selector for text like this:

```yaml
- tapOn: "My text"
```

You can also use other selectors such as id:

```yaml
- tapOn:
    id: "id" # or any other selector
```

For a full list of selectors, please refer to the [Selectors](../selectors.md) page.

### Repeat taps

In some cases it is desirable to repeat taps. To achieve that, the following is possible:

```yaml
- tapOn:
    text: "Button"
    repeat: 3
    delay: 500 # (optional) Delay between taps. Default 100ms

- tapOn:
    id: "someId"
    repeat: 3
```


### retryTapIfNoChange

Sometimes, tapOn will try to tap again if it doesn't detect a hierarchy change. To fix such cases, use retryTapIfNoChange. For example:

```yaml
- tapOn:
    id: "someId"
    retryTapIfNoChange: false
```

In this example, the tapOn will never try to tap again.



### Control wait time

Maestro usually waits for the screen to settle before moving to the next command, however that is not always desirable.

If your app or screen has the following:

* Moving elements like a countdown timer
* Non-blocking animations that are part of the UI

Then, you can use `waitToSettleTimeoutMs` to limit the time Maestro waits for things to settle

```yaml
- tapOn:
    text: "Button"
    waitToSettleTimeoutMs: 500 # ms
```

**Note:** This will be a best effort timeout. Maestro will not interrupt core operations to honor the timeout.

### Tapping on a specific point on the screen

{% hint style="info" %}
Whenever possible, prefer tapping on view id or text instead of coordinates as this might make your tests dependent on a specific type of a device
{% endhint %}

You can specify a relative position on the screen using:

```yaml
- tapOn:
    point: 0%,0%        # top-left corner
- tapOn:
    point: 100%,100%    # bottom-right corner
- tapOn:
    point: 50%,50%      # middle of the screen
```

You can also specify absolute coordinates on the screen to tap on:

```yaml
- tapOn:
    point: 100,200    # This command will tap on point x:100 y:200 on the screen (in pixels)
```

### Tapping on a specific point within another element

If you wish to tap on a point on screen inside another element you can do the following:

```
- tapOn:
    text: "A text with a hyperlink"
    point: "90%,50%"
```

This will find an element with text "A text with a hyperlink" and tapOn towards the end of the sentence where "hyperlink" is located.

### Long press

To long press on a view or a point, use the same exact properties but with a `longPressOn` command:

```yaml
- longPressOn: Text
- longPressOn:
    id: view_id
- longPressOn:
    point: 50%,50%
```

### Long press on a specific point within another element

If you wish to long press on a point on screen inside another element you can do the following:

```
- longPressOn:
    text: "A text with a hyperlink"
    point: "90%,50%"
```

This will find an element with text "A text with a hyperlink" and longPressOn towards the end of the sentence where "hyperlink" is located.

## Example

```yaml
appId: com.android.contacts
---
- launchApp
- tapOn:
    id: .*floating_action_button.* #regex
- inputText: "John"
- tapOn: "Last Name"
- inputText: "Snow"
- tapOn: .*Save.*
```



================================================
FILE: api-reference/commands/toggleairplanemode.md
================================================
# toggleAirplaneMode

`toggleAirplaneMode` allows controlling the airplane mode of the device:

```yaml
- toggleAirplaneMode
```

If you want to explicitely enable or disable the airplane mode, see [setAirplaneMode](./setairplanemode.md).

{% hint style="info" %}
iOS simulators don't have an airplane mode, this is only available on Android.
{% endhint %}



================================================
FILE: api-reference/commands/travel.md
================================================
# travel

The `travel` command can be used to mock the motion of the user, by specifying a set of points (lat/long coordinates) and a speed:

```yaml
- travel:
    points: # set of lat/long coordinates where user motion should be mocked
      - 0.0,0.0
      - 0.1,0.0
      - 0.1,0.1
      - 0.0,0.1
    speed: 7900 # 7.9 km/s aka orbital velocity
```



================================================
FILE: api-reference/commands/waitforanimationtoend.md
================================================
# waitForAnimationToEnd

Waits until an ongoing animation/video is fully finished and screen becomes static.

```yaml
- waitForAnimationToEnd
```

Can have an optional timeout (in milliseconds) after which, if the animation is still running, the command is marked as successful and flow continues regardless. This is a maximum value - if Maestro detects animation has ended before the timeout completes, the flow will continue as normal.

```yaml
- waitForAnimationToEnd:
    timeout: 5000
```



================================================
FILE: api-reference/configuration/README.md
================================================
# Configuration

There are two ways to configure Maestro:

1. With a root `config.yaml` file that is present in the workspace root. Typically this would be `.maestro/config.yaml`
2. Config section for a given Flow. This is the top section in the flow file, above the `---` marker.\
   For example, you specify `appId` among with other things.

{% content-ref url="workspace-configuration.md" %}
[workspace-configuration.md](workspace-configuration.md)
{% endcontent-ref %}

{% content-ref url="flow-configuration.md" %}
[flow-configuration.md](flow-configuration.md)
{% endcontent-ref %}



================================================
FILE: api-reference/configuration/ai-configuration.md
================================================
# AI configuration

{% hint style="info" %}
👤  **Maestro Account** required - create your account for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

Some commands, such as `assertWithAI` and `assertNoDiffWithAI`, use custom AI models, which are not built directly in Maestro CLI. Therefore, to use such commands, additional configuration is required.

{% content-ref url="../commands/assertwithai.md" %}
[assertwithai.md](../commands/assertwithai.md)
{% endcontent-ref %}

{% content-ref url="../commands/assertnodefectswithai.md" %}
[assertnodefectswithai.md](../commands/assertnodefectswithai.md)
{% endcontent-ref %}

### API key

To use this command, an API key for the LLM is required. With the latest changes, we have migrated hard-coded API calls and prompts to our cloud backend, allowing us to enhance these features dynamically without requiring new CLI releases. To set it, export the `MAESTRO_CLOUD_API_KEY` env var.

```console
export MAESTRO_CLOUD_API_KEY=rb_qikYa7g2y5LcDEwLaEDz258ykjRQW7tIaR9K8jLlz6ijqCLTNfnDla3Nd17JF2ealh8kcsYHYyg35M41obGaz85VJz4uqI1orj
```



================================================
FILE: api-reference/configuration/flow-configuration.md
================================================
# Flow configuration

The following properties can be configured on a given Flow:

* `appId`: defines what app the Flow should start when running `launchApp` (required)
* `name`: custom name for the Flow if you don't want to use the filename (optional)
* `tags`: list of tags that this Flow is part of. More information regarding tags can be found [here](../../cli/tags.md). (optional)
* `env`: map of environment variables that should be made available for this Flow
* `onFlowStart`: This is a hook that takes a list of Maestro commands as an argument. These commands will be executed before the initiation of each flow. Typically, this hook is used to run various setup scripts.
* `onFlowComplete`: This hook accepts a list of Maestro commands that are executed upon the completion of each flow. It's important to note that these commands will run regardless of whether a particular flow has ended successfully or has encountered a failure. Typically, this hook is used to run various teardown / cleanup scripts.
* `jsEngine`: Used to override the default JavaScript engine to use another supported engine instead ([docs](../../advanced/javascript/graaljs-support.md)).

{% code title="flow.yaml" %}
```yaml
appId: my.app
name: Custom Flow name
tags:
  - tag-build
  - pull-request
env:
    USERNAME: user@example.com
    PASSWORD: 123
onFlowStart:
  - runFlow: setup.yaml
  - runScript: setup.js
  - <any other command>
onFlowComplete:
  - runFlow: teardown.yaml
  - runScript: teardown.js
  - <any other command>
jsEngine: graaljs
---
- launchApp
```
{% endcode %}



================================================
FILE: api-reference/configuration/workspace-configuration.md
================================================
# Workspace configuration

The directory where all your Maestro-related configuration lives is a _Maestro workspace_ (or just _workspace_ for short).

## Maestro configuration

The following properties can be configured on the workspace as a whole as part of the workspace configuration. All settings are optional.

* `flows`: inclusion patterns regarding what Flows to include ([docs](../../cli/test-suites-and-reports.md#controlling-what-tests-to-include)).
* `includeTags`: list of tags to include on each run ([docs](../../cli/tags.md#global-tags)).
* `excludeTags`: list of tags to exclude on each run ([docs](../../cli/tags.md#global-tags)).
* `executionOrder`: the order to run sequential tests before running remaining tests ([docs](../../cli/test-suites-and-reports.md#sequential-execution)).
* `baselineBranch`: Which branch is your baseline. Useful when integrating with Pull Requests ([docs](https://docs.maestro.dev/cloud/pull-request-integration)). Cloud only.
* `notifications`: Who to notify after an Upload finishes processing ([docs](../../cloud/reference/email-notifications.md)). Cloud only. You might prefer the [Slack integration](../../cloud/reference/slack-notifications.md).

### Example

Below is an example Maestro workspace configuration file. Typically it's named `config.yaml` and placed in the `.maestro` directory in your project's root:

```yaml
flows:
  - "subFolder/*"
includeTags:
  - tagNameToInclude
excludeTags:
  - tagNameToExclude
executionOrder:
    continueOnFailure: false # default is true
    flowsOrder:
        - flowA
        - flowB
  
# Cloud only config options
baselineBranch: main
notifications:
  email:
    enabled: true
    recipients:
      - john@example.com
```



## Environment variables

<table data-view="cards"><thead><tr><th>Variable name</th><th>Description</th><th>Type</th><th>Default</th><th>Further reading</th></tr></thead><tbody><tr><td>MAESTRO_API_URL</td><td>The URL of the Maestro API to use. Probably only useful to Mobile Inc developers.</td><td>String</td><td>https://api.copilot.mobile.dev</td><td>-</td></tr><tr><td>MAESTRO_CLI_AI_KEY</td><td>Key for external AI service used in AI operations</td><td>String</td><td>-</td><td><a href="ai-configuration.md">Docs</a></td></tr><tr><td>MAESTRO_CLI_AI_MODEL</td><td>Model for external AI service used in AI operations. The prefix of the model decides which service to use. If none is specified, OpenAI will be used.</td><td>String</td><td><code>gpt-4o</code> for OpenAI, <code>claude-3-5-sonnet-20240620</code> for Claude</td><td>-</td></tr><tr><td>MAESTRO_CLI_ANALYSIS_NOTIFICATION_DISABLED</td><td>Disables the notification displayed on each run about AI analysis</td><td>Boolean</td><td>false</td><td>-</td></tr><tr><td>MAESTRO_CLI_LOG_PATTERN_CONSOLE</td><td>Sets the <a href="https://logback.qos.ch/manual/layouts.html">logback layout</a> for logging in the console</td><td>String</td><td><code>%highlight([%5level]) %msg%n</code></td><td>-</td></tr><tr><td>MAESTRO_CLI_LOG_PATTERN_FILE</td><td>Sets the <a href="https://logback.qos.ch/manual/layouts.html">logback layout</a> for logging in the log file</td><td>String</td><td><code>%d{HH:mm:ss.SSS} [%5level] %logger.%method: %msg%n</code></td><td><a href="https://docs.maestro.dev/troubleshooting/debug-output#maestro-logs">Docs</a></td></tr><tr><td>MAESTRO_CLI_NO_ANALYTICS</td><td>Disables Maestro analytics collection</td><td>Boolean</td><td>false</td><td>-</td></tr><tr><td>MAESTRO_CLOUD_API_KEY</td><td>The API key to use when communicating with the Maestro cloud platform</td><td>String</td><td>-</td><td><a href="../../cloud/run-maestro-tests-in-the-cloud.md">Docs</a></td></tr><tr><td>MAESTRO_CLOUD_API_URL</td><td>Like <code>MAESTRO_API_URL</code>but used for AI API requests</td><td>String</td><td>https://api.copilot.mobile.dev</td><td>-</td></tr><tr><td>MAESTRO_DISABLE_UPDATE_CHECK</td><td>Disable the check for newer Maestro versions when running the CLI</td><td>Boolean</td><td>false</td><td>-</td></tr><tr><td>MAESTRO_DRIVER_STARTUP_TIMEOUT</td><td>The maximum time to wait for a driver to start</td><td>Number</td><td>15000</td><td><a href="../../advanced/configuring-maestro-driver-timeout.md">Docs</a></td></tr><tr><td>MAESTRO_USE_GRAALJS</td><td>Use GraalJS instead of RhinoJS for JavaScript execution</td><td>Boolean</td><td>false</td><td><a href="../../advanced/javascript/graaljs-support.md">Docs</a></td></tr></tbody></table>

Any other environment variables prefixed with `MAESTRO_` will be available in your Flows as JavaScript variables. See [Accessing variables from the shell](../../advanced/parameters-and-constants.md#accessing-variables-from-the-shell) for more information.



================================================
FILE: cli/cloud.md
================================================
# Cloud

The easiest way to test your Flows in CI is to [run your flows in the cloud](../cloud/run-maestro-tests-in-the-cloud.md). Since your flows run in the cloud there's no need to configure any simulators or emulators on your end.

```
maestro cloud --api-key <API_KEY> --project-id <PROJECT_ID> sample.zip ios-flow.yaml
```

Check out the cloud documentation to get started in less than 5 minutes:

{% content-ref url="../cloud/run-maestro-tests-in-the-cloud.md" %}
[run-maestro-tests-in-the-cloud.md](../cloud/run-maestro-tests-in-the-cloud.md)
{% endcontent-ref %}



================================================
FILE: cli/continuous-mode.md
================================================
# Continuous Mode

This command starts a test in a continuous mode. That is, test will be automatically restarted whenever you make a change to the test file. This is particularly convenient when writing a new test from ground up:

```
maestro test -c flow.yaml
```

Check out the Reference section of the docs to learn about all the commands you can execute.



================================================
FILE: cli/recording-your-flow.md
================================================
# Record Your Flow

<figure><img src="../.gitbook/assets/maestro-record-cover.png" alt=""><figcaption></figcaption></figure>

It's often useful to record a video of your Flow. Some reasons you might want to
do this:

- Showcase a Maestro Flow to your team
- Share a Maestro Flow on social media
- Demonstrate some behavior of your Flow (eg. for debugging purposes)

Maestro makes this easy to do without needing to clean up your desktop, arrange
your windows, or deal with screen recording software.

Simply run the command below to render a beautiful MP4 video of your Flow in
action:

```bash
maestro record YourFlow.yaml
```

Here's an example of the final output:

{% embed url="https://player.vimeo.com/video/775621555?h=736930f7f9" %}

## FAQ

### How does this work?

The `maestro record` command captures the raw Flow output and app screen
recording, and then programmatically stitches them together into an mp4 file.
Today, the rendering is done on mobile.dev servers so the command sends the
screen recording and Flow output securely over the internet to our API.

### Are video URLs private?

Yes - `maestro record` generates [a signed url](https://cloud.google.com/storage/docs/access-control/signed-urls) that is valid for 60 minutes. This means that no one can guess your video url and you are the only one who can download your video (unless you share the signed url). After 60 minutes, the url will be invalidated.

### Why doesn't rendering happen locally?

We'd also prefer to render videos locally, but the rendering logic today
requires dependencies that we'd rather not force our users to install in their
environment. Remote rendering allows `maestro record` to work out of the box
without any additional setup steps.


We may implement local rendering in the future.

### How long are videos stored?

Videos are deleted from our servers after 24 hours.

### what is the maximum duration for a Flow recording?

The maximum duration is two minutes.






================================================
FILE: cli/start-device.md
================================================
---
description: Maestro offers a few convenience methods to start or create a device
---

# Start Device

You can use Maestro to create an Android emulator or an iOS simulator.&#x20;

The device configurations are similar to the ones hosted on [Maestro's cloud platform](../cloud/run-maestro-tests-in-the-cloud.md). Using such devices will help you create compatible flows.



### Start an Android emulator using Maestro

You can start by running

```sh
maestro start-device --platform android
```

This will create a default Android emulator (Pixel 6, Google API 30). If the device already exists, it will simply launch it.

For full options run `maestro start-device`

_Note: Device configurations are limited to a few recommended OS versions and devices. Such configurations work well when_ [_running flows in the cloud_](../cloud/run-maestro-tests-in-the-cloud.md)_._

### Start an iOS simulator using Maestro

You can start by running

```
maestro start-device --platform ios
```

This will create a default iOS simulator (iPhone11, iOS 15.5). If the device already exists, it will simply launch it.

For full options run `maestro start-device`

_Note: Device configurations are limited to a few recommended os versions and devices. Such configurations work well when_ [_running flows in the cloud_](../cloud/run-maestro-tests-in-the-cloud.md)_._




================================================
FILE: cli/tags.md
================================================
# Tags

You can add tags to your Flows files to later filter them in `maestro cloud` and `maestro test` commands. There is a couple of different use cases for this, but this is especially useful when you want to run some Flows at Pull Request time, and other Flows before a version release, for example.

### Adding Tags

You can provide a list of tags in the `tags` field at the root of your Flow file. Like this:

```
appId: com.example.App
tags:
  - nightly-build
  - pull-request
---
- launchApp
```

### Filtering

In `maestro cloud` and `maestro test` commands, you can specify either `--include-tags` or `--exclude-tags` parameters to filter them.

The `--include-tags` will look for all flows containing the provided tag; it doesn't matter if those Flows also have other tags. On the other hand, the `--exclude-tags` parameter will remove from the list of Flows run any Flow that contains the provided tags. These options can be used together and they perform an `AND` operation.

**Example**

Let's say a user has two flows:

```
# flowA.yaml
appId: com.example.app
tags: 
  - dev
  - pull-request
```

```
# flowB.yaml
appId: com.example.app
tags: 
  - dev
```

In the scenario above:

* If they use `--include-tags=dev` , flowA and flowB will run.
* If they use `--include-tags=dev,pull-request` , both flows will run.
* If they use `--exclude-tags=pull-request` , only flowB will run.
* If they use `--exclude-tags=dev` none Flow will run.
* If they use `--include-tags=dev --exclude-tags=pull-request` , only flowB will run.

### Global tags

Instead of passing tags with each `test` or `cloud` command, you can also define default tags to be applied to each run. To do so, add the following to your `config.yaml` file (or create it if it is missing):

```yaml
includeTags:
  - tagNameToInclude
excludeTags:
  - tagNameToExclude
```

Now, whenever you run a test folder the following will happen:

* Only flows with a `tagNameToInclude` are going to run
* Flows with a `tagNameToExclude` are not going to run (even if they have `tagNameToInclude` assigned to them)

When used in combination with `--include-tags` and `--exclude-tags`, global tags behaving as a _union_ and will not be overwritten. Consider the following example:

```
maestro test --include-tags=tagA --exclude-tags=tagB workspaceFolder/
```

The following behaviour should be expected:

* Only flows that have _both_ `tagA` **and** `tagNameToInclude` are going to run
* Flows that have _either_ `tagB` _**or**_ `tagNameToExclude` are not going to run (regardless of whether they have both `tagA` and `tagNameToInclude`)



================================================
FILE: cli/test-suites-and-reports.md
================================================
# Test Suites & Reports

### Running multiple tests

#### Using a folder

Maestro can run a suite of tests that live in a folder and generate a test report at the end.

To run a suite, point `maestro test` to a folder that contains the Flows

```
maestro test myFolderWithTests/
```

Maestro will run every flow from the directory _excluding subfolders_. The command will complete successfully if and only if all the Flows have been completed successfully.

#### Using a list of flows

Maestro can run a list of tests and generate a test report at the end.

To run a list of tests, pass to `maestro test` the Flows paths to the Flows you want to run separated by spaces:

```
maestro test myFolderWithTests/test1.yaml myFolderWithTests/test2.yaml
```

Maestro will run the flow for each file provided. The command will complete successfully if and only if all the Flows have been completed successfully.

### Generating reports

To generate a report, add a `--format` parameter to a `test` command:

```
maestro test --format junit myFolderWithTests/
```

Or, if you are [running in the cloud](../cloud/run-maestro-tests-in-the-cloud.md):

```
maestro cloud --format junit myFolderWithTests/
```

Once execution completes, the report will be stored in a `report.xml` file in a JUnit-compatible format that is supported by most platforms.

#### Supported formats

* `junit` - JUnit XML format

![xml](https://github.com/depapp/maestro-docs/assets/6134774/abcd3d3d-9154-4b49-85b5-274c31997771)

* `html` - HTML format

![html](https://github.com/depapp/maestro-docs/assets/6134774/8fedda56-de5e-411d-8501-63bf3c581e90)

#### Additional options

* `--output {file}` allows to override the report filename

### Controlling what tests to include

There are multiple mechanisms to control what Flows to run when running a test suite.

#### Tags

Flow tags are covered extensively in the following section:

{% content-ref url="tags.md" %}
[tags.md](tags.md)
{% endcontent-ref %}

#### Inclusion Patterns

By default, when running a test suite, only Flows from the top level of a given directory will be executed. Consider the following folder structure:

```
workspace/
  flowA.yaml
  subFolder/
    flowB.yaml
    subSubFolder/
      flowC.yaml
```

When running a `test` or `cloud` command on a `workspace` folder, only `flowA.yaml` will be executed by default (though it is still able to refer to `subFolder/flowB.yaml` and `subFolder/subSubFolder/flowC.yaml` using [`runFlow`](../advanced/nested-flows.md) command).

This behaviour can be customised by using **inclusion** **patterns.** To do that, update your `config.yaml` (create the file if missing) as follows:

```yaml
flows:
  - "*"             # the default behaviour
  - "subFolder/*"
```

In such case, **both** flowA and flowB will be included in the test suite **but not flowC**.

Tests can also be included recursively:

```yaml
flows:
  - "**"
```

In this example, all Flows A, B, and C will be included in the test suite.

### Sequential execution

To run your Flows in a given order, you can add the following configuration to your `config.yaml` file:

```yaml
# config.yaml
executionOrder:
  continueOnFailure: false # default is true
  flowsOrder:
    - flowA
    - flowB
```

This configuration describes to Maestro the order of the Flows you want to run. The list accepts either the Flow file names (without the `.yaml` extension) or the [Flow name](https://maestro.mobile.dev/api-reference/configuration/flow-configuration).

The `continueOnFailure` flag determines whether Maestro should proceed with the execution of subsequent Flows defined in the sequence if a previous one fails. As an example: if `flowA` fails and `continueOnFailure` is `true`, `flowB` will be executed. If the flag is `false`, `flowB` won't be executed. Note that Flows that are not defined in `executionOrder` will not be impacted and will always be run after the sequential Flows, irrespective of this Flow.

{% hint style="warning" %}
Note that your Flows should **not** depend on device state and should be treated as isolated, even though they run in sequence. A good rule of thumb is to ensure that each Flow can be run on a completely reset device.
{% endhint %}

#### Configuring part of the Flows to run sequentially

For instance, if you have three Flows, `flowA`, `flowB`, and `flowC`, but you want to run only `flowA` and `flowB` sequentially, don't add `flowC` and `flowD` to the list. Maestro will run these Flows in non-deterministic ordering **after** the Flow sequence has finished executing.

#### Analyze

{% hint style="warning" %}
This is an **experimental** feature powered by LLM technology. All feedback is welcome.
{% endhint %}

Maestro introduces a new feature that leverages AI to analyze your end-to-end (E2E) mobile tests and provide actionable insights based on your test logs, commands, and screenshots captured during your test runs. The AI-powered analysis identifies potential issues in your app's functionality, UI, and internationalization, helping you improve app quality efficiently.

**Login Requirement:** Before you use the AI analysis feature, ensure you are logged into Maestro. Run the following command:

```bash
maestro login
```

**Analyzing your tests**: To analyze your test flows with AI, use the --analyze flag with the maestro test command:

```bash
maestro test flow-file.yaml --analyze
```

{% hint style="info" %}
While we aim for precision, please note that this is a beta release, and the results should be validated before making critical decision
{% endhint %}

This will enable AI analysis and provide a detailed report based on your test artifacts:

**Examples**

Successful Analysis

Command:

```bash
maestro test flow-file.yaml --analyze
```

Output:

```bash
🔎 Analyzing Flow(s)...

To view the report, open the following link in your browser:
file:///path/to/your/insights-report.html

Analyze support is in Beta. We would appreciate your feedback in our Slack channel: #community-chat

```

<figure><img src="../.gitbook/assets/analyze-report.png" alt=""><figcaption></figcaption></figure>

No Issues Found

If no issues are detected, you will see a message like this:

```bash
Hey, we analyzed your flow for spelling, grammar, and internationalization issues, and good news 🙌 we didn't find any issues!
```

**Disabling Notifications**

To disable the AI analysis notification, set the `MAESTRO_CLI_ANALYSIS_NOTIFICATION_DISABLED` environment variable to true before running Maestro:

```bash
export MAESTRO_CLI_ANALYSIS_NOTIFICATION_DISABLED=true
```

**Feedback**

The Analyze feature is currently in Beta. Share your feedback and suggestions in our Slack channel: [#community-chat](https://mobile-dev-inc.slack.com/archives/C083YB8N42G)



================================================
FILE: cli/view-hierarchy.md
================================================
# View Hierarchy

You can use the Maestro CLI to directly inspect your app view hierarchy.

### hierarchy

`maestro hierarchy` prints out the whole view hierarchy that is currently being shown

```
maestro hierarchy
```

### query

`maestro query` finds an element that matches a condition:

```
maestro query [text=regex] [id=regex]
```



================================================
FILE: cloud/cloud-quickstart.md
================================================
# Cloud Quickstart

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at **maestro.dev**
{% endhint %}

Before wiring into CI, we recommend uploading a local build from your terminal to see the process working end-to-end. These steps should take you less than 5 minutes.

## 1. Install the Maestro CLI

We'll be using the `maestro cloud` command below to run your flows in the cloud, so start by [**installing the Maestro CLI**](../getting-started/installing-maestro/) if you haven't already:

```
curl -Ls "https://get.maestro.mobile.dev" | bash
```

## 2. Retrieve your API Key and Project ID

Log in to the Maestro console, click Settings and copy your Project ID. Please reach out to your mobile.dev representative to obtain your API key.

## 3. Download the Samples

Use the download-samples command to download a sample app and Flow file:

```
maestro download-samples
```

You can of course choose to upload your own app and Flow file, but we recommend using the samples first to see how it works!

## 4. Run your Flow in the cloud

Use the `maestro cloud` command to run your flow in the cloud. This command works the same whether you're running it locally or in CI.

#### Android

```bash
cd ./samples
maestro cloud --api-key <API_KEY> --project-id <PROJECT_ID> sample.apk android-flow.yaml
```

#### iOS

```bash
cd ./samples
maestro cloud --api-key <API_KEY> --project-id <PROJECT_ID> sample.zip ios-flow.yaml
```

To run any flow that depends on other files (like the **advanced** examples) you need to upload the full folder, so that Maestro has all of the files it needs. More information about subflows and what Flows to include can be found [here](../cli/test-suites-and-reports.md#controlling-what-tests-to-include).

To run both Android Flows in the cloud, you can for example run the following command outside of the `samples` folder.

```bash
maestro cloud samples/sample.apk samples
```

## 5. View results in the console

A link to the Maestro console is printed out after your Flow is uploaded successfully. Click on the link to view the results of your upload. It may take a minute or so before your results are ready.

## Congrats 🎉

Congrats, you just ran your first Maestro Flow in the cloud! 🙌

Now that's you've seen how this works locally, let's take a look at how this can be integrated into your CI workflows:

{% content-ref url="ci-integration/" %}
[ci-integration](ci-integration/)
{% endcontent-ref %}



================================================
FILE: cloud/pull-request-integration.md
================================================
# Pull Request Integration

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

Maestro also provides support for native pull request integration. This is useful if you'd like to run your Flows asynchronously but still block pull requests from landing if flow failures are detected.

{% hint style="info" %}
Maestro Cloud currently supports **Pull Request Integration** for GitHub and GitHub Enterprise only.

* ✅ GitHub Support
* ✅ GitHub Enterprise Support

Note that you can trigger [automatic uploads from **any CI platform**](ci-integration/).
{% endhint %}

### 1. Trigger uploads on every pull request

{% tabs %}
{% tab title="GitHub Actions" %}
1. Follow the steps described [here](pull-request-integration.md#github-actions)
2. Ensure your workflow is triggered on every pull request made against your Baseline Branch.

{% code lineNumbers="true" %}
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```
{% endcode %}
{% endtab %}

{% tab title="Maestro CLI" %}
1. Ensure that uploads to Maestro Cloud are triggered on every pull request. Exactly how this is accomplished depends on your CI setup.
2. Add the following options to your `maestro cloud` command:

```
maestro cloud \
  --async \
  --apiKey <apiKey> \
  --branch <branch> \
  --repoOwner <repoOwner> \
  --repoName <repoName> \
  --pullRequestId <pullRequestId> \
  --commitSha <commitSha> \
  <appFile> .maestro/

```

<table data-header-hidden><thead><tr><th width="164"></th><th></th></tr></thead><tbody><tr><td><strong>branch</strong></td><td>Set to the name of the git branch the app was built on and the pull request is based on (i.e. feature-foo)</td></tr><tr><td><strong>repoOwner</strong></td><td>Set to the owner of the repository (i.e. "mobile-dev-inc")</td></tr><tr><td><strong>repoName</strong></td><td>Set to the name of the repository (i.e. "fenix")</td></tr><tr><td><strong>pullRequestId</strong></td><td>Set to the unique identifier of the pull request. Only set when triggered by a Pull Request. (i.e. 1234)</td></tr><tr><td><strong>commitSha</strong></td><td>Set to the commit hash. Only set when triggered by a Pull Request. (i.e. 586e1c690891d20568976c78f06fbec9b94a3b32)</td></tr></tbody></table>


{% endtab %}

{% tab title="API" %}
1. Ensure that uploads are triggered on every pull request. Exactly how this is accomplished depends on your CI setup.
2. Add the following values to the JSON data in the upload API request:

<table data-header-hidden><thead><tr><th width="188"></th><th></th></tr></thead><tbody><tr><td><strong>repoOwner</strong></td><td>Set to the owner of the repository (i.e. "mobile-dev-inc")</td></tr><tr><td><strong>repoName</strong></td><td>Set to the name of the repository (i.e. "fenix")</td></tr><tr><td><strong>branch</strong></td><td>Set to the name of the git branch the app was built on and the pull request is based on (i.e. feature-foo)</td></tr><tr><td><strong>pullRequestId</strong></td><td>Set to the unique identifier of the pull request. Only set when triggered by a pull request. (i.e. 1234)</td></tr><tr><td><strong>commitSha</strong></td><td>Set to the commit hash. Only set when triggered by a Pull Request. (i.e. 586e1c690891d20568976c78f06fbec9b94a3b32)</td></tr></tbody></table>
{% endtab %}
{% endtabs %}

### 2. Grant access to pull requests

In order to update the status of pull requests, you'll need to grant Maestro permissions to do so.

* [Install the Maestro Cloud GitHub App](https://github.com/apps/maestro-cloud-app)

### 3. Test the integration

Lastly, open a pull request and ensure that the Maestro Cloud check shows up on your pull request.

{% tabs %}
{% tab title="GitHub / GitHub Enterprise" %}
<figure><img src="../.gitbook/assets/image (2).png" alt="Successful check on Github PR page"><figcaption></figcaption></figure>
{% endtab %}
{% endtabs %}



================================================
FILE: cloud/run-maestro-tests-in-the-cloud.md
================================================
---
icon: rocket-launch
---

# Run Maestro tests in the cloud



{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

Ship your apps with confidence by running your tests on Maestro's hosted enterprise-grade cloud infrastructure.

## CI Support

You can integrate Maestro into any CI platform via the Maestro CLI, and we're in the process of building out native integrations into the most common platforms. Check out the [**CI Integration docs**](ci-integration/) for details.

<table><thead><tr><th width="225">CI Platform</th><th width="153.3073110285006">Support via CLI</th><th width="385.66666666666674">Native Integration</th></tr></thead><tbody><tr><td><a href="ci-integration/github-actions/"><strong>GitHub Actions</strong></a></td><td>✅</td><td>✅</td></tr><tr><td><a href="ci-integration/bitrise.md"><strong>Bitrise</strong></a></td><td>✅</td><td>✅</td></tr><tr><td><a href="ci-integration/bitbucket-pipelines.md"><strong>Bitbucket</strong></a></td><td>✅</td><td>✅</td></tr><tr><td><a href="ci-integration/circleci.md"><strong>CircleCI</strong></a></td><td>✅</td><td>✅</td></tr><tr><td><a href="ci-integration/integration-with-any-ci-platform.md">All other CI platforms</a></td><td>✅</td><td>-</td></tr></tbody></table>

## Platform Support

<table><thead><tr><th width="572">Platform</th><th align="center">Supported</th></tr></thead><tbody><tr><td><a href="../platform-support/android-views.md">Android - Views</a></td><td align="center">✅</td></tr><tr><td><a href="../platform-support/android-jetpack-compose.md">Android - Jetpack Compose</a></td><td align="center">✅</td></tr><tr><td><a href="../platform-support/ios-uikit.md">iOS - UIKit</a></td><td align="center">✅</td></tr><tr><td><a href="../platform-support/ios-swiftui.md">iOS - SwiftUI</a></td><td align="center">✅</td></tr><tr><td><a href="../platform-support/react-native.md">React Native</a></td><td align="center">✅</td></tr><tr><td><a href="../platform-support/flutter.md">Flutter</a></td><td align="center">✅</td></tr><tr><td><a href="../platform-support/web-views.md">Web Views</a></td><td align="center">✅</td></tr><tr><td><a href="../platform-support/web-desktop-browser.md">Web (Desktop Browser)</a></td><td align="center">✅</td></tr><tr><td>.NET MAUI iOS</td><td align="center">✅</td></tr><tr><td>.NET MAUI Android</td><td align="center">✅</td></tr></tbody></table>

## Getting Started

* If you don't already a Maestro account you can [create your Maestro account here](https://maestro.dev/)
* Maestro cloud testing requires a Cloud Plan, so make sure to start a Cloud Plan Trial before proceeding
* Check out the [Quickstart](cloud-quickstart.md) guide to get started with running your Maestro Flows in the cloud within minutes
* Public Slack Channel: [**Join the workspace**](https://docsend.com/view/3r2sf8fvvcjxvbtk) then head to the `#cloud` channel to discuss anything related to Maestro cloud testing

## Why run in the cloud?

* Guaranteed Parallelism for Consistent Testing
* Unlimited Maestro testing
* Unlimited users
* Test suite reporting
* Automatic CI integration triggers

## We take security seriously

We are SOC 2 compliant meaning that the security and privacy of your data is our top priority\


<figure><img src="../.gitbook/assets/21972-312_SOC_NonCPA.png" alt="" width="180"><figcaption></figcaption></figure>



================================================
FILE: cloud/ci-integration/README.md
================================================
# CI Integration

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

There are two main ways to integrate Maestro cloud testing into your CI workflow:

* Option 1: Install the Maestro CLI and use the `maestro cloud` command
* Option 2: Use Maestro's native CI integration (if it exists for your CI platform)

Follow the link below for your CI platform to learn how to start running your Flows in CI!

<table><thead><tr><th width="243">CI Platform</th><th>Integration</th></tr></thead><tbody><tr><td><strong>GitHub Actions</strong></td><td>Use the <a href="github-actions/">Maestro Cloud GitHub Action</a></td></tr><tr><td><strong>Bitrise</strong></td><td>Use the <a href="bitrise.md">Maestro Cloud Bitrise step</a></td></tr><tr><td><strong>Bitbucket Pipelines</strong></td><td>Use the <a href="bitbucket-pipelines.md">Maestro Cloud Upload Pipe</a></td></tr><tr><td><strong>CircleCI</strong></td><td>Use the <a href="circleci.md">Maestro Cloud Upload Job</a></td></tr><tr><td><strong>GitLab CI/CD</strong></td><td><a href="integration-with-any-ci-platform.md">Use the Maestro CLI</a></td></tr><tr><td><strong>TravisCI</strong></td><td><a href="integration-with-any-ci-platform.md">Use the Maestro CLI</a></td></tr><tr><td><strong>Jenkins</strong></td><td><a href="integration-with-any-ci-platform.md">Use the Maestro CLI</a></td></tr><tr><td>All other CI platforms</td><td><a href="integration-with-any-ci-platform.md">Use the Maestro CLI</a></td></tr></tbody></table>




================================================
FILE: cloud/ci-integration/bitbucket-pipelines.md
================================================
# Bitbucket Pipelines

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

## Setup

In order to use the Maestro Cloud Pipe to run Maestro tests in the cloud, you'll need to add the API key and project IDs as secret environment variables in your Bitbucket repository.

1. Go to your Repository -> Repository settings -> Repository Variables
2. Save your API Key and project id as a secured env variables

## Commit your Maestro Flows to your repository

Create a `.maestro/` directory at the root of your repository and commit your Flows there:

```
<root>
├── .maestro/
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```

It’s common to have some Flow files that are only meant to be executed as part of another Flow via the `runFlow` command. These "subflows" can be nested under a subdirectory to prevent them from running as a top-level Flow.

```
<root>
├── .maestro/
│   ├── subflows/
│   │   └── MySubflow.yaml
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```



## Add Maestro Cloud Pipe

Once everything is setup, you can integrate the [Maestro Cloud Upload Pipe](https://bitbucket.org/product/features/pipelines/integrations?search=maestro\&p=mobiledevinc/maestro-cloud-upload) in your Pipeline build process.&#x20;

Edit your `bitbucket-pipelines.yml` and add an extra step after your app has finished building.

_Note: All file paths are relative to the repository source root._

### Android

```yaml
script:
  - pipe: mobiledevinc/maestro-cloud-upload:1.0.0
    variables:
      MDEV_API_KEY: $MDEV_API_KEY
      MDEV_PROJECT_ID: $MDEV_PROJECT_ID
      MDEV_APP_FILE: app/build/outputs/apk/debug/app-debug.apk
```

### iOS

```yaml
script:
  - pipe: mobiledevinc/maestro-cloud-upload:1.0.0
    variables:
      MDEV_API_KEY: $MDEV_API_KEY
      MDEV_PROJECT_ID: $MDEV_PROJECT_ID
      MDEV_APP_FILE: <app_name>.app
```



The pipe will:

* Upload your app and flows to be run on Maestro's enterprise-grade cloud infrastructure
* Wait for flows to complete (can be configured)
* Complete with fail/pass depending on flow results

## That's it!

For more information and configurations, checkout [Maestro Cloud Upload Pipe](https://bitbucket.org/product/features/pipelines/integrations?search=maestro\&p=mobiledevinc/maestro-cloud-upload).



================================================
FILE: cloud/ci-integration/bitrise.md
================================================
# Bitrise

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

Maestro cloud testing is compatible with all CI systems and provides native integrations with a number of common providers including Bitrise. You can start running your Flows in CI with just a few clicks using the Maestro Cloud Bitrise Step.

### Setting up Bitrise

1. Make sure you have your API key
   1. If you do not have that handy, please reach out to your mobile.dev representative
2. Go to your Bitrise account and save your API key into a secret variable
3. Open the Workflow Editor and select your desired workflow
   1. To add the Maestro step, you can search for "Maestro" in Bitrise's library of steps.&#x20;
   2.  The step should be added after your app binary has been built.\
       \
       \


       <figure><img src="../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>
4. Lastly, fill out the following information in the step configuration:
   1. API Key
   2. Path to your built binary
   3. Project ID
      1. Project ID can be found under "Settings" in the Maestro console
5. That's it! You should now be able to run Maestro tests in the cloud via Bitrise.



================================================
FILE: cloud/ci-integration/circleci.md
================================================
# CircleCI

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

The following guide will help you setup Maestro cloud testing in CircleCI.

#### Save API key and project ID in your repository

First, you'll need to add the API key and Project DI as a secret ENV in your Project Settings

1. Go to your Project -> Project Settings -> Environment Variables
2. Save your API Key and Project ID

<figure><img src="../../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

## Commit your Maestro Flows to your repository

Create a `.maestro/` directory at the root of your repository and commit your Flows there:

```
<root>
├── .maestro/
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```

It’s common to have some Flow files that are only meant to be executed as part of another Flow via the `runFlow` command. These "subflows" can be nested under a subdirectory to prevent them from running as a top-level Flow.

```
<root>
├── .maestro/
│   ├── subflows/
│   │   └── MySubflow.yaml
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```



## Add Maestro Upload Job

Once everything is setup you can integrate maestro by adding another job in your `.circleci/config.yml`

```yaml
maestro-upload:
    docker:
      - image: cimg/openjdk:19.0.1
    steps:
      - attach_workspace:
          at: .
      - run:
          name: Download maestro and run in the cloud
          command: |
            curl -Ls "https://get.maestro.mobile.dev" | bash
            export PATH="$PATH":"$HOME/.maestro/bin"
            maestro cloud \
            --apiKey $MDEV_API_KEY \
            --projectId $MDEV_PROJECT_ID \
            path_to_my_app .maestro
```

_Note: Maestro needs access to your flows and app binary, so make sure to either use_ [_persist\_to\_workspace_](https://circleci.com/docs/workspaces/) _or download the assets when running the upload job._

### Configure

You can configure the upload parameters by modifying the `maestro cloud` command. For example:

```shell
maestro cloud \
--apiKey $MDEV_API_KEY \
--projectId $MDEV_PROJECT_ID \
--name "Custom upload name" \
--async \
-e EMAIL="some@email.com"
-e PASSWORD="some-password"
/tmp/app.apk /tmp/flows
```

You can find all available options by running the Maestro CLI command locally

```shell
> maestro cloud
```

### Example: Android

The following `config.yml` will:

* Build an android app
* Save the workspace and output apk
* Upload your flows and apk

```yaml
version: 2.1
orbs:
  android: circleci/android@2.1.2
jobs:
  build-android:
    executor:
      name: android/android-docker
      tag: 2022.08.1
    steps:
      - checkout
      - android/restore-gradle-cache
      - run:
          name: Assemble debug build
          command: |
            ./gradlew :app:assembleDebug
      - persist_to_workspace:
          root: .
          paths:
            - .
  maestro-upload:
    docker:
      - image: cimg/openjdk:19.0.1
    steps:
      - attach_workspace:
          at: .
      - run:
          name: Upload to Maestro Cloud
          command: |
            curl -Ls "https://get.maestro.mobile.dev" | bash
            export PATH="$PATH":"$HOME/.maestro/bin"
            maestro cloud \
            --apiKey $MDEV_API_KEY \
            --projectId $MDEV_PROJECT_ID \
            app/build/outputs/apk/debug/app-debug.apk .maestro
workflows:
  build-and-upload:
    jobs:
      - build-android
      - maestro-upload:
          requires:
            - build-android
```

### Example: iOS

The following `config.yml` will:

* Build an iOS app
* Save the workspace and output `your_ios_app.app`
* Upload your flows and `.app` binary

```yaml
version: 2.1
jobs:
  build-ios:
    macos:
      xcode: 13.3.1
    environment:
      XCODE_VERSION: "Xcode-13.3.1"
    steps:
      - checkout
      - run:
          name: Switch xcode
          command: sudo xcode-select --switch /Applications/$XCODE_VERSION.app
      - run:
          name: Build iOS app
          command: |
            XCODE_PATH=$(xcode-select -p)
            SIMULATOR_SDKS_AVAILABLE=$(find "$XCODE_PATH/Platforms/iPhoneSimulator.platform/Developer/SDKs/" -type l -maxdepth 1)
            SIMULATOR_SDK_PATH=$(echo "$SIMULATOR_SDKS_AVAILABLE" | head -n1)
            SIMULATOR_SDK=$(basename -s .sdk -a "$SIMULATOR_SDK_PATH" | awk '{print tolower($0)}')
            
            mkdir build
            xcodebuild build \
            -sdk "$SIMULATOR_SDK" \
            -destination 'platform=iOS Simulator' \
            CONFIGURATION_BUILD_DIR=build
      - persist_to_workspace:
          root: .
          paths:
            - .
  maestro-upload:
    docker:
      - image: cimg/openjdk:19.0.1
    steps:
      - attach_workspace:
          at: .
      - run:
          name: Download and run maestro
          command: |
            curl -Ls "https://get.maestro.mobile.dev" | bash
            export PATH="$PATH":"$HOME/.maestro/bin"
            maestro cloud \
            --apiKey $MDEV_API_KEY \
            --projectId $MDEV_PROJECT_ID \
            build/MyApp.app .maestro
workflows:
  build-and-upload:
    jobs:
      - build-ios
      - maestro-upload:
          requires:
            - build-ios
```

## That's it!

If everything was setup correctly, you should be seeing results in your workflow jobs




================================================
FILE: cloud/ci-integration/integration-with-any-ci-platform.md
================================================
# Integration with any CI platform

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

You can use the Maestro CLI to run your Flows in the cloud from any CI platform.

## Prerequisites

<table data-header-hidden><thead><tr><th width="126"></th><th></th></tr></thead><tbody><tr><td><strong>API Key</strong></td><td>Reach out to your mobile.dev representative to obtain your Maestro API key</td></tr><tr><td>Project ID</td><td>The id of the project you want to upload your app and Flows to. You can retrieve this from the Maestro console.</td></tr><tr><td><strong>iOS</strong></td><td>Provide a path that points to an x86-compatible <code>*.app</code> simulator build directory, or a zipped file that contains the <code>*.app</code> build.</td></tr><tr><td><strong>Android</strong></td><td>You APK must be x86-compatible.</td></tr></tbody></table>

## 1.  Organize your Flows

Add all of your Flows under a single directory in your repo. We recommend naming this directory `.maestro/`  as this is the naming convention our native integrations expect by default. (Note the "." at the beginning of `.maestro/`)

```
<root>
├── .maestro/
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```

All of the flows directly under the `.maestro/` directory will be executed as top-level flows.

#### Subflows

It's common to have some Flow files that are only meant to be executed as part of another Flow via the `runFlow` command. These "subflows" can be nested under a subdirectory to prevent them from running as a top-level Flow.

```
<root>
├── .maestro/
│   ├── subflows/
│   │   └── MySubflow.yaml
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```

In the example above, `MySubflow.yaml` will not be executed as a top-level Flow, but still can be referenced by other Flows using the `runFlow` command.

## 2. Run Flows in the cloud

#### 1. Install the Maestro CLI

First, ensure that the [Maestro CLI is installed](../../getting-started/installing-maestro/) on your CI machine:

```shell
curl -Ls "https://get.maestro.mobile.dev" | bash
```

#### 2. Run the "maestro cloud" command

Add a step in your CI workflow that executes the `maestro cloud` command:

```
maestro cloud --apiKey <apiKey> --project-id <projectId> <appFile> .maestro/
```

<table data-header-hidden><thead><tr><th width="144"></th><th></th></tr></thead><tbody><tr><td><strong>&#x3C;apiKey></strong></td><td>Maestro API Key</td></tr><tr><td>&#x3C;projectId></td><td>Maestro Project ID</td></tr><tr><td><strong>&#x3C;appFile></strong></td><td>The APK file or .app directory (<a href="../reference/build-your-app-for-cloud.md">instructions</a>)</td></tr><tr><td><strong>.maestro/</strong></td><td>The directory that contains your Flows</td></tr></tbody></table>

To set a name for your upload, use the `--name` option:

```
maestro cloud --apiKey <apiKey> --project-id <projectId> --name <uploadName> <appFi
```

{% hint style="info" %}
Note that you can also define your API key as an environment variable in your shell with the name `MAESTRO_CLOUD_API_KEY` and Maestro will automatically read it for you
{% endhint %}

## 3. Detect Flow Failures

The `maestro cloud` command and our native CI integrations will wait for your Flows to finish executing before returning.

If any Flow failures are detected, the exit code is set to 1. On success, the exit code will be set to 0. This allows you to leverage any existing test alerting you have in place.

## 4. View Result Details

A link to the current upload will be printed out to your logs. You can view any ongoing or past uploads in the Maestro console.



================================================
FILE: cloud/ci-integration/github-actions/README.md
================================================
# GitHub Actions

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

Maestro cloud testing is compatible with all CI systems and provides native integrations with a number of common providers including GitHub Actions. You can start running your Flows in CI with just a few lines of configuration using the [Maestro Cloud GitHub Action](http://github.com/mobile-dev-inc/action-maestro-cloud).

## Setup

#### Add your API key secret

The GitHub Action will need to authenticate with your Maestro account. So the first step is to expose your API key as a GitHub “Repository Secret”.

**Add your API key as a “Repository Secret”**

1. Navigate to your GitHub repo and click on Settings in top nav bar.
2. In repository settings page click on `Secrets -> Actions`. It will open Action Secrets page.
3. On Action Secrets page, click on `New Repository Secret` button. Use `MAESTRO_API_KEY` as the secret name and paste your Maestro API key from the previous step into the “Secret” value text box. Click “Add Secret” to add the secret.

**Add your Project ID**

The project ID is not a secret, so you either specify it as `project-id` in your workflow file or you add it as an env variable.

**Other setup**

Please refer to the Action documentation [here](https://github.com/marketplace/actions/maestro-cloud-upload-action) to see all configuration options.

## Example

```yaml
name: Build and run Maestro tests (Native Android)

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  maestro-cloud:
    runs-on: ubuntu-latest
    outputs:
      app: app/build/outputs/apk/debug
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: 11
          distribution: 'temurin'
      - run: ./gradlew assembleDebug
      - uses: mobile-dev-inc/action-maestro-cloud@v1
        with:
          api-key: ${{ secrets.MAESTRO_API_KEY }}
          # note that you can supply the project id any way you like, it is not secret
          project-id: ${{ secrets.MAESTRO_PROJECT_ID }}
          app-file: app/build/outputs/apk/debug/app-debug.apk
```

## Commit your Maestro Flows to your repository

Create a `.maestro/` directory at the root of your repository and commit your Flows there:

```
<root>
├── .maestro/
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```

It’s common to have some Flow files that are only meant to be executed as part of another Flow via the `runFlow` command. These "subflows" can be nested under a subdirectory to prevent them from running as a top-level Flow.

```
<root>
├── .maestro/
│   ├── subflows/
│   │   └── MySubflow.yaml
│   ├── Login.yaml
│   ├── Add to Cart.yaml
│   └── Search.yaml
```

## Update your GitHub Actions workflow

Next, you’ll need to update your GitHub Actions workflow to add in the Maestro Cloud step. The workflows above execute generally the same steps for each platform:

* For every `push or pull_request` to `main` branch trigger this job
* Build the application
* Upload the built application and Flow files to Maestro Cloud
* Note the `MAESTRO_API_KEY` is the same secret you added to your Github repository earlier

### Usage examples

Below you can find various examples for different platforms for how to structure your GitHub action to build and upload your app to Maestro Cloud:

{% content-ref url="maestro-github-action-for-android.md" %}
[maestro-github-action-for-android.md](maestro-github-action-for-android.md)
{% endcontent-ref %}

{% content-ref url="maestro-github-action-for-ios.md" %}
[maestro-github-action-for-ios.md](maestro-github-action-for-ios.md)
{% endcontent-ref %}

{% content-ref url="maestro-github-action-for-flutter.md" %}
[maestro-github-action-for-flutter.md](maestro-github-action-for-flutter.md)
{% endcontent-ref %}

## That’s it!

Check out the Maestro Cloud Action [README](https://github.com/mobile-dev-inc/action-maestro-cloud) for more information on how to configure the step.



================================================
FILE: cloud/ci-integration/github-actions/maestro-github-action-for-android.md
================================================
# Maestro GitHub Action for Android

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

```
name: Build and run Maestro tests (Native Android)

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  maestro-cloud:
    runs-on: ubuntu-latest
    outputs:
      app: app/build/outputs/apk/debug
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: 11
          distribution: 'temurin'
      - run: ./gradlew assembleDebug
      - uses: mobile-dev-inc/action-maestro-cloud@v1
        with:
          api-key: ${{ secrets.MAESTRO_API_KEY }}
          # note that you can supply the project id any way you like, it is not secret
          project-id: ${{ secrets.MAESTRO_PROJECT_ID }}
          app-file: app/build/outputs/apk/debug/app-debug.apk
```



================================================
FILE: cloud/ci-integration/github-actions/maestro-github-action-for-flutter.md
================================================
# Maestro GitHub Action for Flutter

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

## Android

```yaml
name: Build and run Maestro tests (Flutter Android)

on:
  workflow_dispatch:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  upload:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          channel: "stable"
      - run: flutter build apk --debug
      - uses: mobile-dev-inc/action-maestro-cloud@v1
        with:
          api-key: ${{ secrets.MAESTRO_CLOUD_API_KEY }}
          # note that you can supply the project id any way you like, it is not secret
          project-id: ${{ secrets.MAESTRO_PROJECT_ID }}
          app-file: build/app/outputs/flutter-apk/app-debug.apk
```

## iOS

```yaml
name: Build and run Maestro tests (Flutter iOS)

on:
  workflow_dispatch:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ios:
    runs-on: macos-13
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          channel: "stable"
      - run: flutter build ios --debug --simulator
      - uses: mobile-dev-inc/action-maestro-cloud@v1
        with:
          api-key: ${{ secrets.MAESTRO_CLOUD_API_KEY }}
          # note that you can supply the project id any way you like, it is not secret
          project-id: ${{ secrets.MAESTRO_PROJECT_ID }}
          app-file: build/ios/iphonesimulator/Runner.app # replace `Runner` with your app name
```



================================================
FILE: cloud/ci-integration/github-actions/maestro-github-action-for-ios.md
================================================
# Maestro GitHub Action for iOS

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

```
name: Build and run Maestro tests (Native iOS)

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macOS-latest
    steps:
      - uses: actions/checkout@v2
      - run: xcodebuild build -scheme 'MyApp' -configuration Debug -project 'MyApp.xcodeproj' -destination 'generic/platform=iOS Simulator' CONFIGURATION_BUILD_DIR=$PWD/build
      - uses: mobile-dev-inc/action-maestro-cloud@v1
        with:
          api-key: ${{ secrets.MAESTRO_CLOUD_API_KEY }}
          # note that you can supply the project id any way you like, it is not secret
          project-id: ${{ secrets.MAESTRO_PROJECT_ID }}
          app-file: build/MyApp.app
```



================================================
FILE: cloud/reference/README.md
================================================
# Reference




================================================
FILE: cloud/reference/build-your-app-for-cloud.md
================================================
# Build your app for the cloud

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

## iOS

### Building with Xcode command line tools

To build an app with Xcode command line tools **xcrun xcodebuild** should be used. Here is an example on how to build an app called `MyApp` for iOS simulator target:

```
xcodebuild -project MyApp.xcodeproj \
-scheme MyApp \
-configuration Debug \
-destination 'generic/platform=iOS Simulator' \
CONFIGURATION_BUILD_DIR=$PWD/build
```

The `.app file` will then be located `build/` folder, which can be modified via the last parameter of the script.

### Building with Fastlane

If you use [fastlane](https://fastlane.tools/) for your automation pipelines the script should look the following way:

```
xcodebuild(
      configuration: build_config[:configuration],
      scheme: build_config[:scheme],
      workspace: build_config[:xcode_workspace],
      xcargs: "-quiet -sdk 'iphonesimulator' -destination 'generic/platform=iOS Simulator'",
      derivedDataPath: IOS_DERIVED_DATA_PATH # this will contain the .app which we need later on
)
```

### Building with Flutter

If you use Flutter to build your app you can create a debug build for simulators using the following command:

```
flutter build ios --debug --simulator
```

You can then find your app file in the `build/ios/iphonesimulator/` directory.

## Android

Android app binary requirements:

* APK (AAB not supported)
* Compatible with x86\_64 architecture
* Release and Debug builds both supported

## Building with Gradle

Build your app using one of the commands below. Then find the appropriate APK file in the `build/outputs/apk/` output directory.

```sh
# Release build
./gradlew assembleRelease

# Debug build
./gradlew assembleDebug
```

## Building with Flutter

If you use Flutter to build your app you can create a debug build using the following command:

```bash
# Release build
flutter build apk

# Debug build
flutter build apk --debug
```

You can then find the built apk in the `build/app/outputs/`folder.



================================================
FILE: cloud/reference/configuring-device-locale.md
================================================
# Configuring device locale

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

`maestro cloud` supports testing different app locales by changing a device locale for a given upload automatically by setting `--device-locale` parameter. The parameter `--device-locale` is a combination of [`ISO-639-1`](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) `+` [`ISO-3166-1`](https://en.wikipedia.org/wiki/ISO_3166-1) with using underscore `_` symbol in between them. If the parameter is omitted default `en_US` locale will be used. Here are some example usages:

```
// sets device locale to German(Germany)
maestro cloud --device-locale de_DE <app_file_path> <workspace_path>
// sets device locale to Japanese(Japan)
maestro cloud --device-locale ja_JP <app_file_path> <workspace_path>
```

Full list of supported locales can be found [here](../../advanced/testing-in-different-locales.md).



================================================
FILE: cloud/reference/configuring-os-version.md
================================================
# Configuring OS Version

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

### Android

You can configure your Flows to run on a specific Android OS version (API level) using the `android-api-level` parameter when running the `maestro cloud` command:

```
maestro cloud --android-api-level 30 myapp.apk myflows/
```

If you're using one of the CI integrations, please refer to the CI documentation for your specific integration:

{% content-ref url="../ci-integration/" %}
[ci-integration](../ci-integration/)
{% endcontent-ref %}

#### Emulator specs

* x86\_64 architecture
* Android API 33 (Google APIs) **(Default)**
* 606x1280, 244 dpi\


**Supported API levels:**

| Android Version             | API Level                  |
| --------------------------- | -------------------------- |
| Android 14 Upside Down Cake | 34 (Google APIs)           |
| Android 13 Tiramisu         | 33 (Google APIs) (default) |
| Android 12 Snow Cone        | 31 (Google APIs)           |
| Android 11 Red Velvet Cake  | 30 (Google APIs)           |
| Android 10 Quince Tart      | 29 (Google APIs)           |

### iOS

Flows will be run on iOS simulators&#x20;

#### Simulator Specs

* x86 architecture
* iOS version 16 (default)
* iPhone 11
* 828x1792, 326 ppi

**Supported iOS runtimes:**

* iOS 16 (default)
* iOS 17

You can configure your Flows to run on a specific iOS major version using the `ios-version` parameter when running the `maestro cloud` command:

```
maestro cloud --ios-version 17 myapp.app myflows/
```

Maestro will automatically select an appropriate minor version, meaning that if you specify iOS 16 your Flows will for example be run on 16.2. If you happen to specify a minimum deployment target version that is below the selected minor version (for example 16.0), an error message will be surfaced with instructions on how to recover.\



================================================
FILE: cloud/reference/device-timezones.md
================================================
# Device timezones

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

Android emulator instances and macOS instances (iOS flows are executed on iOS simulators) are located in following regions and timezones.

| Device type | Region\*\*                                                                 | Timezone |
| ----------- | -------------------------------------------------------------------------- | -------- |
| Android     | us-west1-a ([gcloud](https://cloud.google.com/compute/docs/regions-zones)) | UTC      |
| iOS         | vegas                                                                      | GMT -7   |

\*\* In here region represents a physical location of an emulated (linux instance with hosted Android emulator) / simulated (macOS instance with iOS simulator) environment. Device has an ability to override some of those settings, i.e. timezone of an Android emulator is UTC by default.



================================================
FILE: cloud/reference/email-notifications.md
================================================
# Email Notifications

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

You can set up Maestro to notify you and your team when a Flow in the cloud. That's useful to easily keep track if your app is working as expected.&#x20;

In the `config.yaml` file add the list of emails that should receive the notifications:

```
# .maestro/config.yaml
notifications:
  email:
    enabled: true
    recipients:
      - john@something.com
      - alice@something.com
      ... any other emails you want to send notifications to
```

{% hint style="info" %}
Note that the `config.yaml` file should be present in the root of your workspace along with your Flows, which by default is `.maestro` if you do not explicitly pass another folder as the workspace.
{% endhint %}

When a Flow fails, you will receive an email like this:

<figure><img src="../../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

### Receiving notifications on success

By default, emails are only sent when a failure is detected. If you want to be notified on successful runs as well, add `onSuccess: true` to your config:

```
# .maestro/config.yaml
notifications:
  email:
    enabled: true
    onSuccess: true
    recipients:
      - john@something.com
      - alice@something.com
      ... any other emails you want to send success notifications to
```

<figure><img src="../../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>



================================================
FILE: cloud/reference/ip-allowlist.md
================================================
# IP Allowlist

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

If your network requires external services to be on an allowlist (formerly called a whitelist) to allow access, you can use the following lists to update your ACLs.

* 207.254.42.234
* 34.127.79.8
* 35.247.62.137
* 34.83.16.33\


These IPs addresses will not change, but we reserve the right to add more IPs in the future. Contact us to join a mailing list to be notified of future changes.



================================================
FILE: cloud/reference/limits.md
================================================
# Limits

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

### Execution limit (soft limit)

There is a soft limit of 15 minutes, which means that after 15 minutes of execution your test may be stopped at any time after that.



================================================
FILE: cloud/reference/managing-secrets.md
================================================
# Managing Secrets

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

There might be cases where you don't want to store certain values in a flow file itself (i.e. user name, password, etc.). Maestro solves that by taking such parameters as [variables](managing-secrets.md#using-variables-in-your-flows).

{% tabs %}
{% tab title="Maestro CLI" %}
Pass in parameters using the `-e` option:

```
maestro cloud \
  --api-key <apiKey>
  --project-id <projectId>
  -e USERNAME=$TEST_USERNAME \
  -e PASSWORD=$TEST_PASSWORD \
  <appFile> .maestro/
```
{% endtab %}

{% tab title="Github Action" %}
Parameters are provided as multiline `env` field

```yaml
- uses: mobile-dev-inc/action-maestro-cloud@v1
      with:
        api-key: ${{ secrets.MOBILE_DEV_API_KEY }}
        app-file: <path to APK or iOS Simulator build>
        env: |
            USERNAME=${{ secrets.TEST_USERNAME }}
            PASSWORD=${{ secrets.TEST_PASSWORD }}
```
{% endtab %}
{% endtabs %}

### Using variables in your flows

Once you have defined the variables, you can refer to them in your flows:

```
appId: your.app.id
---
- launchApp
- inputText: ${USERNAME}
- tapOn: Next
- inputText: ${PASSWORD}
```



================================================
FILE: cloud/reference/reusing-app-binary.md
================================================
# Reusing App Binary

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

### Why to reuse an app binary?

To execute a variety of test scenarios on the same build, multiple `maestro upload` requests are often necessary. Since a binary upload can be time-consuming and resource-intensive, Maestro offers a solution to optimize this process. By using the **`--app-binary-id`** option, provided after a successful upload, users can reuse the cached binary for subsequent uploads, saving both time and space.

### Finding the app binary ID

After uploading, the app binary id will be returned in the CLI response

<figure><img src="../../.gitbook/assets/app_binary.png" alt=""><figcaption></figcaption></figure>

It's also visible at the top of a run in the Maestro console

<figure><img src="../../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

### Using the app binary ID

#### --app-binary-id

You can now re-use a previous app binary by providing the appBinaryId. This will skip binary re-upload and improve iteration speed.

Example usage:

```
maestro cloud --api-key=123 --project-id=456 --app-binary-id=1 myFlows/
```

#### Convenience params --app-file, --flows

You can now specify appFile and flow(s) via an argument.

Example usage:

**Flows folder**

```
maestro cloud --api-key=123 --project-id=456 --app-file=app.apk --flows=myFlows/
```

**Single Flow file**

```
maestro cloud --api-key=123 --project-id=456 --app-file=app.apk --flows=flow.yaml
Why to reuse an app binary?
To execute a variety of test scenarios on the same build, multiple maestro upload requests are often necessary. Since a binary upload can be time-consuming and resource-intensive, Maestro offers a solution to optimize this process. By using the --app-binary-id option, provided after a successful upload, users can reuse the cached binary for subsequent uploads, saving both time and space.
Surface app binary
After uploading, the app binary id will be returned in the CLI response

--app-binary-id
You can now re-use a previous app binary by providing the appBinaryId. This will skip binary re-upload and improve iteration speed.
Example usage:
maestro cloud --api-key=123 --project-id=456 --app-binary-id=1 myFlows/
Convenience params --app-file, --flows
You can now specify appFile and flow(s) via an argument.
Example usage:
(Flows folder)
maestro cloud --api-key=123 --project-id=456 --app-file=app.apk --flows=myFlows/
(Single Flow file)
maestro cloud --api-key=123 --project-id=456 --app-file=app.apk --flows=flow.yaml
```

### Security Concerns

#### Does this mean that someone else can access your app?

No. This is just a shortcut for you to grab the binary from your last upload rather that sending the same 1s and 0s over the internet again. Further, all devices are wiped after every single test - even you don't have access to the running app once the test is complete.



================================================
FILE: cloud/reference/slack-notifications.md
================================================
# Slack Notifications

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}

You can set up Maestro to notify you and your team about results from **a specific project when** [running in the cloud](../run-maestro-tests-in-the-cloud.md). That's useful to easily keep track if your app is working as expected.

1. Go to the settings in your Maestro Console

<figure><img src="../../.gitbook/assets/robin-console-settings.png" alt=""><figcaption></figcaption></figure>

2.  Click on the `Connect Slack` button

    {% hint style="info" %}
    Then you are going to be redirected to the slack page, where you need to authorize the integration and select the channel you want to receive the notifications.
    {% endhint %}

<figure><img src="../../.gitbook/assets/slack-integration-redirect.png" alt=""><figcaption></figcaption></figure>

3. After you have authorized the integration, you will be redirected back to the Maestro Console, and the integration will be enabled.

<figure><img src="../../.gitbook/assets/slack-bot-onboarding.png" alt=""><figcaption></figcaption></figure>

4. That's it! When an upload finishes a message will be posted in your channel.

<figure><img src="../../.gitbook/assets/slack-bot-successful-upload.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/slack-bot-failure-upload.png" alt=""><figcaption></figcaption></figure>

5. If you want to disable the integration or change the channel that receives the notifications, you can easily do it in the settings page.

<figure><img src="../../.gitbook/assets/settings-update-slack-bot.png" alt=""><figcaption></figcaption></figure>

**Coming soon:**

* Customize the message that is sent to the channel
* Receive notifications only for failed uploads
* AI integration



================================================
FILE: cloud/reference/webhook-integration.md
================================================
# Webhook Notifications

{% hint style="info" %}
🚀 **Cloud Plan** required - get started for free at [**maestro.dev**](https://www.maestro.dev/)
{% endhint %}


You can set up Maestro to send webhook notifications about upload results from **a specific project**. This allows you to integrate upload events with your custom workflows, monitoring systems, or other external services.

1. Go to the settings in your Maestro Console 

{% hint style="info" %}
Webhooks provide a flexible way to receive real-time notifications about upload events programmatically.
{% endhint %}

2.  Navigate to the Project Settings page

3.  Configure your Webhook URL

    - Enter the full URL where you want to receive webhook notifications
    <figure><img src="../../.gitbook/assets/webhook-management-settings.png" alt="Webhook Settings"></figcaption></figure>

4.  Get your Webhook Token

    Copy the token provided in the settings page, to use it in your webhook endpoint as the Bearer Token.

    <figure><img src="../../.gitbook/assets/webhook-management-token.png" alt="Webhook URL Configuration"></figcaption></figure>

5.  Verify and Enable the Webhook

    {% hint style="warning" %}
    Ensure your webhook endpoint can handle POST requests and is publicly accessible.
    {% endhint %}

6.  Webhook Payload Example

When an upload event occurs, a POST request will be sent to your configured URL with a JSON payload:

```json
{
  "id": "mupload_123456",
  "name": "TestApp Release 1.2.3",
  "url": "https://app.maestro.dev/project/project-abc123/maestro-test/app/com.example.testapp/upload/upload-123456",
  "platform": "ANDROID",
  "appId": "com.example.testapp",
  "githubBranch": "main",
  "envVariables": {
    "API_ENDPOINT": "https://api.example.com",
    "FEATURE_FLAG_ENABLED": "true"
  },
  "startTime": 1659312000000,
  "endTime": 1659315600000,
  "flows": [
    {
      "id": "run_789012",
      "name": "Login Flow Test",
      "url": "https://app.maestro.dev/project/project-abc123/maestro-test/flow/run-789012",
      "status": "SUCESS",
      "failureReason": null,
      "startTime": 1659312000000,
      "endTime": 1659312300000
    },
    {
      "id": "run_789013",
      "name": "Checkout Flow Test",
      "url": "https://app.maestro.dev/project/project-abc123/maestro-test/flow/run-789013",
      "status": "FAILURE",
      "failureReason": "Element with ID 'checkout_button' not found",
      "startTime": 1659312600000,
      "endTime": 1659312900000
    },
    {
      "id": "run_789014",
      "name": "User Profile Flow",
      "url": "https://app.maestro.dev/project/project-abc123/maestro-test/flow/run-789014",
      "status": "SUCESS",
      "failureReason": null,
      "startTime": 1659313200000,
      "endTime": 1659313500000
    }
  ]
}
```

7.  Manage Webhook Integration

- You can update or disable the webhook at any time in the settings
- You can have multiple webhooks configured for the same project
- Test your webhook configuration with a sample payload




================================================
FILE: community/articles-and-tutorials.md
================================================
---
description: A list of articles, blog posts and tutorials
---

# Articles & Tutorials

* [Best Practices for Cross-platform Maestro UI Testing for Android and iOS](https://blog.mobile.dev/best-practices-for-cross-platform-maestro-ui-testing-for-android-and-ios-98d1c471a838)
* [Streamline Your React Native Testing with Maestro](https://viniciuspetrachin.medium.com/streamline-your-react-native-testing-with-maestro-bc279586125f)
* [Getting started with Maestro. The new mobile UI testing framework from Mobile.dev (Bitrise.io)](https://bitrise.io/blog/post/getting-started-with-maestro-the-new-mobile-ui-testing-framework-from-mobile-dev)



================================================
FILE: community/contributions.md
================================================
---
description: A list of community projects and contributions around Maestro.
---

# Contributions

* [VSCode Maestro Workbench](https://github.com/Mastersam07/maestro-workbench/)\
  Maestro Workbench is a Visual Studio Code extension offering features such as IntelliSense, syntax highlighting, formatting, test execution, and output visualization to streamline your workflow.
* [VSCode Maestro Assistant](https://github.com/agens-no/vscode-maestro-assistant)\
  Maestro Assistant is a Visual Studio Code extension that provides useful Maestro shortcuts and simplifies repetitive workflows, like creating or running flows.
* [React Native Maestro](https://github.com/kiki-le-singe/react-native-maestro)\
  A sample project that uses Maestro to test a React Native app built with Expo.
* [E2E testing of React Native apps using EAS and Maestro (Expo documentation)](https://docs.expo.dev/build-reference/e2e-tests/)
* [Codemagic CI integration](https://docs.codemagic.io/integrations/maestro-integration/)
* [Fastlane Plugin](https://github.com/inf2381/fastlane-plugin-maestro)
* [ASDF Plugin](https://github.com/dotanuki-labs/asdf-maestro)
* [Maestro Test Results to Slack](https://github.com/brett-james-rocketlab/maestro-test-results-to-slack)\
  Parses Maestro results in a given folder and posts to Slack.



================================================
FILE: community/resources.md
================================================
---
description: A list of articles, blog posts and tutorials
---

# Resources

* Blog Post: [**Introducing: Maestro — Painless Mobile UI Automation**](https://blog.mobile.dev/introducing-maestro-painless-mobile-ui-automation-bee4992d13c1)
* GitHub Repository: [**https://github.com/mobile-dev-inc/maestro**](https://github.com/mobile-dev-inc/maestro)
* Public Slack Channel: [**Join the workspace**](https://docsend.com/view/3r2sf8fvvcjxvbtk), then head to the `#maestro-questions` channel



================================================
FILE: examples/advanced-wikipedia-android.md
================================================
---
description: A complete example using Maestro + Wikipedia App
---

# Advanced: Wikipedia Android

## Content

* Go through onboarding
* Navigate dashboard
  * Scroll feed & search for item
  * Copy text & paste
  * Validate visible items
* Authentication
  * Signup
  * Login
* Use javascript

{% embed url="https://youtu.be/qmEy_0VRHq8" %}

{% hint style="info" %}
Use `maestro download-samples` to download the app and code
{% endhint %}

## Onboarding

1. Launches app in clear state
2. Runs onboarding flow
   1. Add language
   2. Remove language
   3. Complete onboarding

```yaml
# run-test.yml
appId: org.wikipedia
---
- launchApp:
    clearState: true
- runFlow: "onboarding/main.yml"
```

{% tabs %}
{% tab title="main.yml" %}
```yaml
# onboarding/onboarding.yml
appId: org.wikipedia
---
- runFlow: "add-language.yml"
- runFlow: "remove-language.yml"
- tapOn: "Continue"
- assertVisible: "New ways to explore"
- tapOn: "Continue"
- assertVisible: "Reading lists with sync"
- tapOn: "Continue"
- assertVisible: "Send anonymous data"
- tapOn: "Get started"
```
{% endtab %}

{% tab title="add-language.yml" %}
```yaml
# onboarding/add-language.yml
appId: org.wikipedia
---
- tapOn: "ADD OR EDIT.*"
- tapOn: "ADD LANGUAGE"
- tapOn:
    id: ".*menu_search_language"
- inputText: "Greek"
- assertVisible: "Ελληνικά"
- tapOn: "Ελληνικά"
- tapOn: "Back"
```
{% endtab %}

{% tab title="remove-language.yml" %}
```yaml
# onboarding/remove-language.yml
appId: org.wikipedia
---
- tapOn: "ADD OR EDIT.*"
- tapOn: "More options"
- tapOn: "Remove language"
- tapOn:
    id: ".*wiki_language_checkbox"
    index: 1
- tapOn:
    id: ".*menu_delete_selected"
- tapOn: "OK"
- assertNotVisible: "Ελληνικά"
- tapOn: "Back"
```
{% endtab %}
{% endtabs %}

```sh
maestro test run-test.yml
```

{% embed url="https://youtu.be/AR8ISrzhVeA" %}

### Navigate main dashboard

1. Search & Save
   1. Searches for a wiki page
   2. Saves the wiki page in favorites
   3. Returns to main dashboard
2. Feed
   1. Scroll feed until it finds a particular article
   2. Opens article
3. Copy & Paste
   1. Scrolls feed until it finds a particular article
   2. Copies article title
   3. Pastes copied text into another field
4. Saved
   1. Vaidates a particular page has been saved in our favorites

```yaml
# run-test.yml
appId: org.wikipedia
---
- launchApp
- runFlow: "dashboard/search.yml"
- runFlow: "dashboard/feed.yml"
- runFlow: "dashboard/copy-paste.yml"
- runFlow: "dashboard/saved.yml"
```

{% tabs %}
{% tab title="search.yml" %}
```yaml
appId: org.wikipedia
---
- tapOn: "Search Wikipedia"
- inputText: "Sun"
- assertVisible: "Star in the Solar System"
- tapOn:
    id: ".*page_list_item_title"
- tapOn:
    id: ".*page_save"
- back
- back
```

{% embed url="https://youtu.be/lUVnvTZi1aA" %}
{% endtab %}

{% tab title="feed.yml" %}
```yaml
appId: org.wikipedia
---
- tapOn: "Explore"
- scrollUntilVisible:
    element: "Today on Wikipedia.*"
- tapOn: "Today on Wikipedia.*"
- back
```

{% embed url="https://youtu.be/Sn924uHpsH4" %}
{% endtab %}

{% tab title="copy-paste.yml" %}
```yaml
appId: org.wikipedia
---
- tapOn: "Explore"
- scrollUntilVisible:
    element: "Top read"
- copyTextFrom:
    id: ".*view_list_card_item_title"
    index: 0
- tapOn: "Explore"
- tapOn: "Search Wikipedia"
- inputText: "${maestro.copiedText}"
- back
- back
```

{% embed url="https://youtu.be/iiv7A1TIFcU" %}
{% endtab %}

{% tab title="saved.yml" %}
```yaml
appId: org.wikipedia
---
- tapOn: "Saved"
- tapOn: "Default list for your saved articles"
- assertVisible: "Sun"
- assertVisible: "Star in the Solar System"
- back
```

{% embed url="https://youtu.be/V_mVRicKEnU" %}
{% endtab %}
{% endtabs %}

```sh
maestro test run-test.yml
```

### Authentication

1. Signup
   1. Navigates to signup
   2. Generates credentials using javascript
   3. Fills input fields with generated credentials
2. Login
   1. Navigates to login
   2. Fetches a test user from a test api using javascript
   3. Fill input fields with fetched credentials

```yaml
# run-test.yml
appId: org.wikipedia
---
- launchApp
- runFlow: "auth/signup.yml"
- runFlow: "auth/login.yml"
```

{% tabs %}
{% tab title="login.yml" %}
```yaml
appId: org.wikipedia
---
- tapOn: "More"
- tapOn: "LOG IN.*"
- tapOn:
    id: ".*create_account_login_button"
- runScript: "fetchTestUser.js"
- tapOn: "Username"
- inputText: "${output.test_user.username}"
- tapOn: "Password"
- inputText: "test-password"
- tapOn: "LOG IN"
# we won't actually login

- back
- back
```

{% embed url="https://youtu.be/AUxW_shTg7I" %}
{% endtab %}

{% tab title="signup.yml" %}
```yaml
appId: org.wikipedia
---
- tapOn: "More"
- tapOn: "LOG IN.*"
- runScript: "generateCredentials.js"
- tapOn: "Username"
- inputText: "${output.credentials.username}"
- tapOn: "Password"
- inputText: "${output.credentials.password}"
- tapOn: "Repeat password"
- inputText: "${output.credentials.password}"
- tapOn: "Email.*"
- inputText: "${output.credentials.email}"
# We won't actually create the account

- back
- back
```

{% embed url="https://youtu.be/bqG-n9sAUVI" %}
{% endtab %}
{% endtabs %}

#### Javascript scripts

{% tabs %}
{% tab title="generateCredentials.js" %}
```javascript
function username() {
  const date = new Date().getTime().toString();
  return `test_user_${date}`;
}

function email() {
  const date = new Date().getTime().toString();
  return `test-user-${date}@test.com`;
}

function password() {
  const date = new Date().getTime().toString();
  return `test-user-password-${date}`;
}

output.credentials = {
  email: email(),
  password: password(),
  username: username(),
};

```
{% endtab %}

{% tab title="fetchTestUser.js" %}
```javascript
// Fetches test user from API
function getTestUserFromApi() {
  const url = `https://jsonplaceholder.typicode.com/users/1`;
  const response = http.get(url);
  const data = json(response.body);

  return {
    username: data.username,
    email: data.email,
  };
}

output.test_user = getTestUserFromApi();
```
{% endtab %}
{% endtabs %}

```bash
maestro test run-test.yml
```



================================================
FILE: examples/android-contacts-flow-automation.md
================================================
# Android contacts flow automation

{% embed url="https://player.vimeo.com/video/779079600?h=0b1fec8f26" %}

This flow demonstrates how Maestro can automate saving a contact with name, phone number & email of a person.

Some notable interactions in this Flow:

1. Clicking on any element using: tapOn
2. Random data input using: inputRandomPersonName,inputRandomNumber & inputRandomEmail
3. Android back navigation using: back

## **Flow File**

{% code title="# contacts.yaml" %}
```yaml
appId: com.android.contacts
---
- launchApp
- tapOn: "Create new contact"
- tapOn: "First name"
- inputRandomPersonName
- tapOn: "Last name"
- inputRandomPersonName
- tapOn: "Phone"
- inputRandomNumber:
    length: 10
- back
- tapOn: "Email"
- inputRandomEmail
- tapOn: "Save"
```
{% endcode %}

## **How to run the flow**

1. Install maestro in your system. ([Installation instructions](../getting-started/installing-maestro/))
2. Copy the YAML flow from below in your system and save it as contacts.yaml
3. Start android emulator in your system
4. Run this command from your terminal: `maestro test contacts.yaml`



================================================
FILE: examples/facebook-signup-flow-automation.md
================================================
# Facebook signup flow automation

{% embed url="https://player.vimeo.com/video/765491505?h=21d7adf282" %}

This flow demonstrates how Maestro can automate signing up with Facebook.

{% hint style="info" %}
Note: Facebook has since added checks in their app to prevent this flow from being automated.
{% endhint %}

Some notable interactions in this Flow:

1. Clicking on any element using: `tapOn`
2. Long pressing an element using: `longPressOn`
3. Asserting visibility of element using: `assertVisible`
4. Keyboard press using: `pressKey`
5. Random data input using: `inputRandomPersonName`, `inputRandomNumber`, `inputRandomText` & `inputRandomEmail`
6. Android back navigation using: `back`

## **Flow File**

{% code title="facebook.yaml" %}
```yaml
appId: com.facebook.katana
---
- launchApp:
    appId: "com.facebook.katana"
    clearState: true
- tapOn: "Create new Facebook account"
- assertVisible: "Join Facebook"
- tapOn: "Next"
- assertVisible: "Allow Facebook to access your contacts?"
- tapOn: "Allow"
- assertVisible: "Allow Facebook to make and manage phone calls?"
- tapOn: "Allow"
- inputRandomPersonName
- tapOn: "Last Name"
- inputRandomPersonName
- tapOn: "Next"
- assertVisible: "What's your birthday?"
- longPressOn:
    id: "android:id/numberpicker_input"
    index: 0
- inputText: "Jan"
- longPressOn:
    id: "android:id/numberpicker_input"
    index: 1
- inputText: "01"
- longPressOn:
    id: "android:id/numberpicker_input"
    index: 2
- inputText: "2000"
- pressKey: Enter
- tapOn: "Next"
- tapOn: "Male"
- tapOn: "Next"
- tapOn: "Sign up with email address"
- assertVisible: "Enter your email address"
- inputRandomEmail
- tapOn: "Next"
- assertVisible: "Choose a password"
- inputRandomText
- tapOn: "Next"
- tapOn: "Sign up"
```
{% endcode %}




================================================
FILE: examples/page-object-model.md
================================================
---
description: A guide to implementing Page Object Model within Maestro
---

# Page Object Model

## Content

* [Introduction](page-object-model.md#introduction)
* [Login Page example](page-object-model.md#login-page-example)
  * [login.js](page-object-model.md#login.js)
* [Nested example](page-object-model.md#nested-example)
  * [cards.js](page-object-model.md#cards.js)
* [How to structure and tips](page-object-model.md#how-to-structure-and-tips)
  * [Folder structure example](page-object-model.md#folder-structure-example)
  * [Ensuring all elements are loaded](page-object-model.md#ensuring-all-elements-are-loaded)
    * [loadElements.yaml](page-object-model.md#loadelements.yaml)
    * [flow.yaml](page-object-model.md#flow.yaml)
* [Cross-platform example](page-object-model.md#cross-platform-example)

## Introduction

Implementating a Page Object Model has many benefits:

* Improved readability, abstraction and grouping
* Reducing unnecessary duplication
* Improving test/flow maintenance

It allows you to update an element in one place which will then cascade throughout all of your tests/flows. This can save a lot of time when elements are modified and also assist in easier debugging of issues.

## Login Page example

### login.js

```javascript
// login.js
output.login = {
    email: 'email_text',
    password: 'password_text',
    loginBtn: 'loginButton',
    registerBtn: 'registerButton'
}
```

You can then use these variables to reference element IDs, text or even other test data:

```yaml
- runScript: login.js
- tapOn:
    id: ${output.login.email}
- inputText: "simon@maestro.com"
- tapOn:
    id: ${output.login.password}
- inputText: ${PASSWORD}
- tapOn:
    id: ${output.login.loginBtn}
```

## Nested example

### cards.js

```yaml
// cards.js
output.cards = {
    cardName: 'card_title',
    cardImage: 'card',

    // All Cards Screen
    allCards: {
	createNewBtn: 'btnyam_create',
	cardImage: 'card_image',
	cardName: 'card_title'
    },

    // Virtual Cards
    virtualCards: {
	createNewBtn: 'btn_create',
	cardDetails: {
	    cardNumber: 'card_number',
   	    expiryDate: 'card_expiry'
	}
    }
}
```

You can create nested element structures to better separate/organise screens and flows. Using the example below, it's easy to define a separate structure for Virtual Cards within the overall Cards object. You could then use them in your flows as follows:

```yaml
- runScript: cards.js
- tapOn:
    id: ${output.cards.virtualCards.createNewBtn}
- assertVisible:
    id: ${output.cards.virtualCards.cardDetails.cardNumber}
```

## How to structure and tips

### Folder structure example

Creating an elements folder is good practice as it allows you to keep all of your element files together.

```
android/
    cards/
    elements/
	cards.js
	help.js
	home.js
	loadElements.yaml
	login.js
	nav.js
    home/
    login/
iOS/
    cards/
    elements/
	cards.js
	help.js
	home.js
	loadElements.yaml
	login.js
	nav.js
    home/
    login/
```

### Ensuring all elements are loaded

Once you begin creating numerous js files to cover all of your app screens and elements, it can become tricky to remember if you've included the right ones at the start of your test, especially if your flow is crossing multiple areas. A nice trick is to simply add your `runScript` command once to a single common flow, and then you can run that parent flow once at the start of all your other flows to ensure all of your screens and elements are loaded in correctly.

#### loadElements.yaml

```yaml
# loadElements.yaml
appId: com.appid
---
- runScript: cards.js
- runScript: home.js
- runScript: login.js
- runScript: nav.js
- runScript: tabBar.js
```

Usage:

#### flow.yaml

```yaml
appId: com.appID
---
- runFlow: elements/loadElements.yaml
- launchApp
// Test Steps
```

## Cross-platform example

If you have the same app across both Android and iOS but the elements have different IDs, you can employ `runFlow` with a platform conditional to load in the correct elements.

```yaml
- runFlow:
    when:
        platform: Android
    commands:
        - runScript:
            file: android_elements/login.js
- runFlow:
    when:
	platform: iOS
    commands:
	- runScript:
	    file: iOS_elements/login.js
```



================================================
FILE: getting-started/maestro-studio.md
================================================
---
description: Your personal assistant to help write your Maestro Flows
---

# Maestro Studio

{% embed url="https://youtu.be/g6HaT6CzUrk" %}

Use Maestro Studio to instantly discover the exact commands needed to interact with your app.

Here’s how it works:

### Launch Maestro Studio <a href="#b415" id="b415"></a>

Maestro Studio is built right into the Maestro CLI. Upgrade your CLI to the latest version, and run the command below to launch Maestro Studio in your browser:

```bash
maestro studio
```

Here’s what you’ll see:

<figure><img src="../.gitbook/assets/Screenshot 2023-07-13 at 18.54.53.png" alt=""><figcaption></figcaption></figure>

You can either visually select UI elements in order to receive suggestions on how to interact with the element in your Flow, or enter Maestro commands in the REPL and run them by pressing `Run`.

### Visually Select a UI Element <a href="#2508" id="2508"></a>

Click on the device screenshot to select a UI element, e.g. Settings icon on the iOS simulator.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2023-07-13 at 18.58.06.png" alt=""><figcaption></figcaption></figure>

#### Automatically Generated Examples <a href="#725d" id="725d"></a>

Maestro Studio automatically generates examples of how you can interact with the selected element in your Flows. You can double click on the example to execute it directly, or use the hotkeys to copy it to the clipboard or open the relevant documentation.

### Executing commands in the REPL

You can execute Maestro commands inline in Studio in the REPL view. The commands are written in YAML in the same way as you would write any normal Flow.



<figure><img src="../.gitbook/assets/Screenshot 2023-07-17 at 19.12.37.png" alt=""><figcaption></figcaption></figure>



================================================
FILE: getting-started/run-a-sample-flow.md
================================================
# Run a Sample Flow

{% hint style="info" %}
If you want to get started writing your own Flow right away, skip ahead to the [**next section**](writing-your-first-flow.md).
{% endhint %}

### Download the Samples

Use the download-samples command to download the samples:

```shell
maestro download-samples
```

This will download the build-in sample Flows and app into a `samples/` folder in your current directory.

### Run the Sample Flow

Install the sample app and then run the associated Flow using the `maestro test` command.

{% tabs %}
{% tab title="iOS" %}
```shell
cd ./samples
unzip sample.zip
xcrun simctl install Booted Wikipedia.app
maestro test ios-flow.yaml
```
{% endtab %}

{% tab title="Android" %}
```
cd ./samples
adb install sample.apk
maestro test android-flow.yaml
```
{% endtab %}
{% endtabs %}



================================================
FILE: getting-started/running-flows-on-ci.md
================================================
# Running Flows on CI

### Running in the Cloud

The easiest way to test your flows in CI is to run your flows on Maestro's enterprise-grade hosted cloud infrastructure. Since your flows run in the cloud there's no need to configure any simulators or emulators on your end. Check out the docs to get started in less than 5 minutes:

{% content-ref url="../cloud/run-maestro-tests-in-the-cloud.md" %}
[run-maestro-tests-in-the-cloud.md](../cloud/run-maestro-tests-in-the-cloud.md)
{% endcontent-ref %}

### Alternatives

Maestro CLI can run flows on any Android device/emulator that supports ADB connections and any iOS simulator that supports Facebook's IDB. You can manually orchestrate your flow execution against any provider that supports these protocols. Just use the Maestro CLI to run your flows like you would locally.



================================================
FILE: getting-started/writing-your-first-flow.md
================================================
# Writing Your First Flow

Write a test in a YAML file

```yaml
# flow.yaml

appId: your.app.id
---
- launchApp
- tapOn: "Text on the screen"
```

Make sure an Android device/emulator or iOS simulator is running ([instructions](installing-maestro/#android)) and app is correctly installed on a selected device ([instructions](build-and-install-your-app/)).

Run it!

```
maestro test flow.yaml
```



================================================
FILE: getting-started/build-and-install-your-app/README.md
================================================
# Build and Install your App

Currently maestro supports emulator and device builds for Android (**.apk**) and iOS Simulator (**.app**). More details on how to build an app for Maestro are in the following platform sections.



================================================
FILE: getting-started/build-and-install-your-app/android.md
================================================
# Android

Android app binary requirements:

* APK (AAB not supported)
* Compatible with x86\_64 architecture
* Requires Android API level 26 or newer
* Release and Debug builds both supported

## Building with Gradle

Build your app using one of the commands below. Then find the appropriate APK file in the `build/outputs/apk/` output directory.

```sh
# Release build
./gradlew assembleRelease

# Debug build
./gradlew assembleDebug
```

## Building with Flutter

If you use Flutter to build your app you can create a debug build using the following command:

```bash
# Release build
flutter build apk

# Debug build
flutter build apk --debug
```

You can then find the built apk in the `build/app/outputs/`folder.



================================================
FILE: getting-started/build-and-install-your-app/ios.md
================================================
# iOS

## Building with Xcode

Maestro currently supports iOS Simulator builds (**.app**), AppStore distribution device builds (**.ipa**) are not currently supported. The easiest way to get an app installed on the simulator is by building and running it from Xcode (make sure that simulator target is selected):

<figure><img src="../../.gitbook/assets/Screenshot 2023-02-15 at 13.46.55.png" alt=""><figcaption></figcaption></figure>

## Default build location

If you want to install the .app manually, the file can be found under the Products folder at Xcode Menu:\
\
**Product -> Show Build Folder in Finder -> Then go to path Products/Debug-iphonesimulator**

The .app file can then be installed on the simulator by simple dragging and dropping the file or via Xcode command line tools by running:

```
xcrun simctl install $DEVICE_UDID /path/to/your/app
```

## Building with Xcode command line tools

To build an app with Xcode command line tools **xcrun xcodebuild** should be used. Here is an example on how to build [Food Truck](https://github.com/apple/sample-food-truck) app for iOS simulator target:

```
xcrun xcodebuild -scheme 'Food Truck' \
-project 'Food Truck.xcodeproj' \
-configuration Debug \
-sdk 'iphonesimulator' \
-destination 'generic/platform=iOS Simulator' \
-derivedDataPath \
build
```

The .app file can be then found under **/build** folder

## Building with Fastlane

If you use [fastlane](https://fastlane.tools/) for your automation pipelines the script should look the following way:

```
xcodebuild(
      configuration: build_config[:configuration],
      scheme: build_config[:scheme],
      workspace: build_config[:xcode_workspace],
      xcargs: "-quiet -sdk 'iphonesimulator' -destination 'generic/platform=iOS Simulator'",
      derivedDataPath: IOS_DERIVED_DATA_PATH # this will contain the .app which we need later on
)
```

## Building with Flutter

If you use Flutter to build your app you can create a debug build for simulators using the following command:

```
flutter build ios --debug --simulator
```

You can then find your app file in the `build/ios/iphonesimulator/` directory.



================================================
FILE: getting-started/installing-maestro/README.md
================================================
# Installing Maestro

## Installing the CLI

{% hint style="info" %}
**Using Windows?** Follow this guide to get set up on a Windows machine: [Installing Maestro on Windows](windows.md)
{% endhint %}

Run the following command to install Maestro on macOS, Linux or Windows (WSL):

```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash
```

If you're on macOS, you can use Homebrew instead of the install script above:

```bash
brew tap mobile-dev-inc/tap
brew install maestro
```

## Upgrading the CLI

Simply run the installation script again:

```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash
```

## Installing a specific version of Maestro

To install a specific version, export the `MAESTRO_VERSION` environment variable
and run the same installation command as before:

```bash
export MAESTRO_VERSION={version}; curl -Ls "https://get.maestro.mobile.dev" | bash
```

[See the list of available versions](https://github.com/mobile-dev-inc/maestro/releases).

## Installing a specific version of Maestro in a Dockerfile

Define a variable for the version you want to install:

```dockerfile
ENV MAESTRO_VERSION {version}
```

Then download Maestro and add it to your path:

```dockerfile
RUN mkdir -p /opt/maestro && \
wget -q -O /tmp/${MAESTRO_VERSION} "https://github.com/mobile-dev-inc/maestro/releases/download/cli-${MAESTRO_VERSION}/maestro.zip" && \
unzip -q /tmp/${MAESTRO_VERSION} -d /opt/ && \
rm /tmp/${MAESTRO_VERSION}
ENV PATH=/opt/maestro/bin:${PATH}
```

## Connecting to Your Device

`maestro test` will automatically detect and use any local emulator or
USB-connected physical device.

_Note: At the moment, Maestro does not support physical iOS devices_



================================================
FILE: getting-started/installing-maestro/linux.md
================================================
# Linux

Follow the default install instructions

{% content-ref url="./" %}
[.](./)
{% endcontent-ref %}



================================================
FILE: getting-started/installing-maestro/macos.md
================================================
# macOS

Dependencies:

* [Xcode](https://developer.apple.com/xcode/) (recommended version is 14 or higher)\
  \
  Please make sure that Command Line Tools are installed (Xcode -> Preferences -> Locations -> Command Line Tools)

After setting up the macOS dependencies above, follow the default installation instructions:

{% content-ref url="./" %}
[.](./)
{% endcontent-ref %}



================================================
FILE: getting-started/installing-maestro/windows.md
================================================
---
description: A step by step guide to installing Maestro on Windows
---

# Windows



## Option 1: Installation on Windows

{% stepper %}
{% step %}
#### Download the latest Maestro Release

{% embed url="https://github.com/mobile-dev-inc/maestro/releases/latest/download/maestro.zip" %}
{% endstep %}

{% step %}
#### Extract the Maestro zip

Extract the zip file you downloaded in the previous step to any location. For instance:

```shell
C:\Users\jake\maestro
```
{% endstep %}

{% step %}
#### Update your PATH environment variable

Update your PATH environment variable to include the `maestro\bin` folder. You may need to restart your terminal for this to take effect.

```
setx PATH "%PATH%;C:\Users\jake\maestro\bin"
```
{% endstep %}

{% step %}
#### Connect to a device

`maestro test` will automatically detect and use any local emulator or USB-connected physical device.
{% endstep %}
{% endstepper %}

## Option 2: Installation in WSL2

If you prefer WSL2 for your working environment, this section will walk you through the end-to-end steps for getting started with Maestro on a Windows machine.&#x20;

Note: It's more involved than installing Maestro on Windows directly, and requires passing additional configuration at runtime too.

### Pre-Requisites

1. PowerShell is installed in your Windows system.
2. Install Android Studio on your Windows machine.
3. Add ANDROID\_HOME to your Windows environment variable.
   1. To check if your ANDROID\_HOME setup is correctly done, open a PowerShell terminal and run this command `adb --version.`
   2. Note down the ADB version.
4. Install Java JDK 11 and set JAVA\_HOME
   1. Run `java --version` to check if the Java is installed correctly.

### Steps

1. Install WSL2 (Window Subsystem for Linux)
2. Install Java 21
3. Install Maestro

#### 1. Install WSL 2

With recent Windows 11, Microsoft has made it pretty easy to install Windows Subsystem for Linux, aka WSL.

In order to install WSL, open PowerShell as administrator and run the following command:

```bash
wsl --install
```

After running the above command, follow through instructions and restart the computer.

Install [Windows Terminal](https://github.com/microsoft/terminal) application for refreshing terminal experience.

Set your Linux username and password (Something that you will not forget).

Run the following two commands to update your Ubuntu system. Enter password when prompted.

```bash
sudo apt update
sudo apt upgrade
```

#### 2. Install Java

After restarting the system, open the Terminal application and click on the dropdown to select Ubuntu. Type in the following command:

```bash
sudo apt install openjdk-21-jdk
```

#### 3. Install Maestro

Installing Maestro is now just a matter of running following one command.

```shell
     curl -Ls "https://get.maestro.mobile.dev" | bash
```

**Tada! 🎉**

**You have successfully installed Maestro on your Windows machine** 🙌

Check your Maestro version using the following command:

```bash
maestro --version
```

### What's Next?

#### Let's set you up to use Android in your freshly installed WSL2

* Download the Android command line tools zip file from [Android official site.](https://developer.android.com/studio)
* Use the following instructions to set up Android command lines correctly in your WSL2.
  * Open WSL2 terminal.
  *   Create a new directory in your home directory.

      ```shell
      ~ $ mkdir Android
      ~ $ cd Android
      ```
  * Unzip the Android command line tools zip file in the `android` directory using this command: `unzip ~<command_line_zip_filename>.zip`
  *   In the `Android` directory perform following actions.

      ```shell
      $ mkdir latest
      $ mv cmdline-tools/* latest/
      $ mv latest/ cmdline-tools/
      ```

      **Note:** Last command will probably give you a warning, but you don’t need the worry about that.
  *   Now add the following line to your `~/.bashrc file`

      ```shell
      export ANDROID_HOME=$HOME/Android
      export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
      ```
  * Save your `~/.bashrc` file and exit.
  * Run `source ~/.bashrc` to reload the bashrc file.
  * Now, we will install basic Android utilities using the following commands:
    * Run `sdkmanager --list` to check if everything is working fine.
    * Run `sdkmanager --install "platform-tools"` to install platform tools.
  * Finally, add the following into your `~/.bashrc` file
    * `export PATH=$PATH:$ANDROID_HOME/platform-tools`
    * Save your `~/.bashrc` file and exit.
    * Run `source ~/.bashrc` to reload the bashrc file.
  * To check that everything went well, do the following:
    * Close and relaunch terminal
    * Run `adb --version` and see that adb version is shown
    * Since everything is installed fresh, your WSL 2 adb version should perfectly match with Windows ADB version that we noted down as part of the pre-requisites.

Please follow the below steps to setup the ADB and make sure you are able to use Android emulators with your WSL2 correctly:

* Launch your Android emulator on Windows.
* Once the Android emulator is up and running, open a PowerShell prompt.
*   Run this command in PowerShell

    ```powershell
    adb -a -P 5037 nodaemon server
    ```
* This will start the adb server in the Windows host.
* Note down the IPV4 address of your Windows host PC/machine.

TROUBLESHOOTING:

* Sometimes you may get `smartsockets..` error when you run `adb -a -P 5037 nodaemon server` command in PowerShell. In that case, you can do the following steps:
  * Open task manager and kill all `adb` related processes.
  * If Android Studio is open, close it and **keep only** emulator running.
  * If you see a message saying `emulator offline`, **ignore it**.
  * Sometimes, the firewall stops your connection with the host machine. For that, add a firewall rule to allow the connection or check with your organization system admin if using a company machine.
* **Note: Don't close the PowerShell terminal!**
* Now open your WSL2 terminal and run these commands:
  * `adb kill-server`
  * `export ADB_SERVER_SOCKET=tcp:<WINDOWS_IPV4_ADDR>:5037`
  * `adb devices`
  * `You should see your connected emulator successfully now.`

#### Ready to start Using Maestro?

Yes, at this point, you are free to start your automation.

* [Write your first flow](https://maestro.mobile.dev/getting-started/writing-your-first-flow)
* How to run **Maestro commands**?
  * You can run Maestro commands in WSL2 terminal with `--host` flag. eg.
    * _**maestro --host \<WINDOWS\_IPV4\_ADDR> test flow.yaml**_
    * _**maestro --host \<WINDOWS\_IPV4\_ADDR> studio**_
* Check out the [full documentation](https://maestro.mobile.dev/)

### Known Issues

* If your Android emulator is not up and running in the Windows host, the Maestro test command fails to find the installed emulator. At this point, it is recommended that you fire up your emulator before running the flow using Maestro.



================================================
FILE: platform-support/android-jetpack-compose.md
================================================
# Android - Jetpack Compose

<figure><img src="../.gitbook/assets/compose.png" alt=""><figcaption></figcaption></figure>

Maestro supports Jetpack Compose.

## Interacting with composable with Text

Given a composable with a displayed text:

```kotlin
Text(
    text = "Like",
    modifier = Modifier.fillMaxWidth(),
    textAlign = TextAlign.Center,
    style = MaterialTheme.typography.titleMedium,
    fontWeight = FontWeight.Bold
)
```

You can use the following command to tap on this `Text` :

```yaml
- tapOn: "Like"
```

## Interacting with composable with Accessibility

Given a composable without text, you can use semantics:

For the following composable:

```kotlin
FloatingActionButton(onClick = onClick, 
    modifier = Modifier
        .semantics { testTagsAsResourceId = true }.testTag("Add")
) {
    Icon(Icons.Filled.Add, "")
}
```

You can tap on this using `testTag`:&#x20;

```yaml
- tapOn: 
    id: "Add"
```

{% content-ref url="broken-reference" %}
[Broken link](broken-reference)
{% endcontent-ref %}

## Resources

* [How to automate your UI testing using Maestro](https://composables.com/jetpack-compose-tutorials/maestro)



================================================
FILE: platform-support/android-views.md
================================================
# Android - Views

<figure><img src="../.gitbook/assets/android (1).png" alt=""><figcaption></figcaption></figure>

Maestro fully supports native Android apps. Maestro tests can also run on real hardware devices.

{% content-ref url="broken-reference" %}
[Broken link](broken-reference)
{% endcontent-ref %}

## Interacting with views by text

Any view with a `text` property can be tapped on:

```xml
<Button
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Hello World" />
```

Can be tapped in the following way:

```yaml
tapOn: Hello World
```

## Interacting with views by id

Views can be accessed by their ids. For example:

```xml
<Button
    android:id="@+id/myButton"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Hello World" />
```

Can be tapped in the following way:

```yaml
- tapOn:
    id: myButton
```

## Interacting with views by contentDescription

`contentDescription` field is surfaced as text property and can be interacted in the same way as any view containing `text`:

```xml
<ImageView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:contentDescription="Hello World" />
```

This view can then be tapped using the following command:

```yaml
- tapOn: Hello World
```

## Known Limitations

1. Unicode text **input** is not yet currently supported. Though views that have unicode in them can still be interacted with.



================================================
FILE: platform-support/flutter.md
================================================
# Flutter

<figure><img src="../.gitbook/assets/flutter.png" alt=""><figcaption></figcaption></figure>

Flutter is a first class citizen for Maestro. It can test both pure and hybrid (i.e [add-to-app](https://docs.flutter.dev/add-to-app)) Flutter mobile apps.

## Interacting with widgets by semantics label

Maestro can interact with widgets that have semantics information attached. By default, this includes all widgets that display text (`data` in the Text widget, `hintText` in the TextField, and so on). You can also attach semantics information to any widget using Flutter's [Semantics widget](https://api.flutter.dev/flutter/widgets/Semantics-class.html).

### Example: Tap on a widget

Given an `InkWell` widget with a `Text` widget child:

{% code fullWidth="false" %}
```dart
InkWell(
  child: Text('Open Browser'),
  onTap: () => launch('https://mobile.dev'),
)
```
{% endcode %}

The following command will tap on it:

```yaml
- tapOn: Open Browser
```

***

Some widget, such as `Icon`, don't have implicit semantics. In such cases you can often pass a `semanticLabel`:

```dart
FloatingActionButton(
  onPressed: _incrementCounter,
  child: Icon(Icons.add, semanticLabel: 'fabAddIcon'),
)
```

Then the `FloatingActionButton` can be interacted with using the following command:

```yaml
- tapOn: fabAddIcon
```

{% hint style="info" %}
The `Icon` widget simply creates a `Semantics` widget itself – [see the source](https://github.com/flutter/flutter/blob/3.16.0/packages/flutter/lib/src/widgets/icon.dart#L303-L314).
{% endhint %}

***

Finally, you can wrap any widget with [Semantics](https://api.flutter.dev/flutter/widgets/Semantics-class.html):

```dart
Semantics(
  label: 'funky yellow box',
  child: Container(
    color: Colors.yellow,
    width: 100,
    height: 100,
  ),
)
```

```yaml
- tapOn: funky yellow box
```

### Example: Enter text in a widget

To enter text in the following text field widget:

```dart
TextField(
  decoration: InputDecoration(
    border: UnderlineInputBorder(), 
    labelText: 'Enter your username',
  ),
)
```

Use this command:

```yaml
- tapOn: Enter your username
- inputText: charlie_root
```

### Example: Assert a widget is visible

```dart
Text(
  'Welcome back, dear $fullName! 👋🎉',
  semanticsLabel: 'Welcome back, dear $fullName!',
),
```

```yaml
- assertVisible: Welcome back, dear Test User!
```

{% hint style="info" %}
In cases where both `semanticLabel` and text label are provided (like above), the `semanticLabel` takes precedence. It's recommended to use `maestro studio` in such cases to easily identify what label to use.
{% endhint %}

## Interacting with widgets by semantic identifier

When your app grows, testing often becomes harder.

Maybe the app gets multi-language support, and now you have to decide on the language in which you test it. Maybe some of the strings displayed are non-static (e.g. becase of A/B tests). And the sheer number of screens makes tests harder to maintain.

When you start facing these problems, you should consider using the **accessibility identifier** instead of semantics labels.

{% hint style="info" %}
This is a new feature that [we contributed to Flutter](https://github.com/flutter/engine/pull/47961) to make it easier to test apps made with it. It's available on the stable channel since Flutter 3.19 (released on February 15th, 2024). To use it, upgrade to the latest stable Flutter release:

```
flutter channel stable
flutter upgrade
```
{% endhint %}

### Example: Tap on a widget by semantics identifier

```dart
Semantics(
  identifier: 'signin_button',
  child: ElevatedButton(
    onPressed: _signIn,
    child: Text('Sign in'),
  ),
)
```

```yaml
- tapOn:
    id: signin_button
```

### Example: Enter text in a widget by semantics identifier

```dart
Semantics(
  identifier: 'username_textfield',
  child: TextField(
    decoration: InputDecoration(
      border: UnderlineInputBorder(), 
      labelText: 'Enter your username',
    ),
  ),
)
```

```yaml
- tapOn:
    id: username_textfield
- inputText: charlie_root
```

## Good practices

Let's say you have a `FancyButton` widget in your app. These buttons are important for you, and you want to ensure they always have an accessibility identifier assigned so they can be reliably interacted with using Maestro. The code sample below requires all callers of `FancyButton` to pass an accessibility identifier:

```dart
class FancyButton extends StatelessWidget {
 FancyButton({
    super.key,
    required this.identifier,
    required this.onPressed,
  });

  final String identifier;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: identifier,
      child: RawMaterialButton(
        onPressed: onPressed,
        // ...
      ),
    );
  }
}
```

This also has the benefit of reducing widget nesting at the call site:

```dart
FancyButton(
  identifier: 'buy_premium',
  onPressed: _buyPremium,  
)

// instead of:

Semantics(
  identifier: 'buy_premium',
  FancyButton(
    onPressed: _buyPremium,
  ),
)
```

Of course, there's always danger of a developer accidentally not using the `FancyButton` widget and defering to the built-in `ElevatedButton`. To combat that, we recommend setting up lint rules that forbid using `ElevatedButton` and enforce replacing it with a `FancyButton` instead. For example you can use [the leancode_lint package](https://pub.dev/packages/leancode_lint) with the following configuration in `analysis_options.yaml`:

```yaml
include: package:leancode_lint/analysis_options.yaml

custom_lint:
  rules:
    - use_design_system_item:
      FancyButton:
        - instead_of: ElevatedButton
          from_package: flutter
          
analyzer:
  plugins:
    - custom_lint
```

## Why not Flutter keys?

Flutter widget keys cannot be used in Maestro because there's no linkage between widget keys and Flutter's accessibility bridge system. This makes using Keys impossible since Maestro is accessibility-tree based.

Also, Flutter API docs for the [Key class](https://api.flutter.dev/flutter/foundation/Key-class.html) and [Widget.key field](https://api.flutter.dev/flutter/widgets/Widget/key.html) say it's for "controlling how one widget replaces another (e.g. in a list)". Keys are just not a mechanism for assigning unique IDs to widgets for testing purposes.

We strongly recommend making your app accessible (not just for UI tests, but for all of your users with different needs). When testing at scale, you should also consider using an accessibility identifier.

Here's also a little trick that you may find useful if you really want to use keys in Maestro (using the `FancyButton` example from above):

```dart
class FancyButton extends StatelessWidget {
  FancyButton({
    required String key,
    required this.onPressed,
  })  : _key = key,
        super(key: ValueKey(key));

  final String _key;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: _key,
      child: RawMaterialButton(
        onPressed: onPressed,
        // ...
      ),
    );
  }
}
```

Callers are required to pass a string key:

```dart
FancyButton(
  key: 'unlock_reward',
  onPressed: _unlockReward,
)
```

And you can easily interact with the widget using Maestro:

```yaml
- tapOn:
    id: unlock_reward
```

## Known Limitations

Maestro cannot be used to test Flutter Desktop or Flutter Web apps (yet).



================================================
FILE: platform-support/ios-swiftui.md
================================================
# iOS - SwiftUI

<figure><img src="../.gitbook/assets/swiftui.png" alt=""><figcaption></figcaption></figure>

Maestro fully supports iOS apps that use SwiftUI.\
\
In addition to iOS UIKit apps it is possible to write maestro flows for the apps that are written in SwiftUI. For showcasing the capabilities of maestro two open-source apps were picked - [Food Truck app](https://github.com/artem888/sample-food-truck) from WWDC22 and [SwiftUI Kit app](https://github.com/artem888/SwiftUI-Kit) that demonstrates different SwiftUI components in a storybook manner.

### Basic flow

First lets start with some basic flow for FoodTruck app. Almost every SwiftUI native element is identifiable with maestro studio. For instance here is how the first step of [first\_flow.yaml](https://github.com/artem888/sample-food-truck/blob/main/.mobiledev/first\_flow.yaml) was generated:

<figure><img src="../.gitbook/assets/Screenshot 2023-01-12 at 21.48.45.png" alt=""><figcaption></figcaption></figure>

`index: 0` can be omitted and the first step of the flow looks like that:

```yaml
- tapOn:
    text: "New Orders"
```

All the other steps in this flow were generated the same way, following examples provided by `maestro studio`. \
\
The [flow](https://github.com/artem888/sample-food-truck/blob/main/.mobiledev/text\_input.yaml) itself navigates to order details screen, marks that an order is completed and finally asserts that the order is not in the list anymore, which can be considered as real-world use-case scenario.

### Text Input

[Here is an example](https://github.com/artem888/sample-food-truck/blob/main/.mobiledev/text\_input.yaml) of a flow that relies on the text input.

```yaml
// First typing on the element that has a prewritten placeholder text:
- tapOn:
    text: "New Donut"
    index: 1

// Erasing the text completely
- eraseText

// input new contents for the TextField
- inputText: "Test Donut"
```

There is a better way to focus on a TextField rather than watching on its contents - accessibility id / label, which is explained in the next section.

### Accessibility info

The best practice to write reliable flows with maestro for SwiftUI is to assign `accessibilityIdentifier` or `accessibilityLabel` for UI element that needs to be accessed.

Here is the code modification that needed to be done for the Food Truck to make `tapOn` work with id:

```swift
NavigationLink(value: Panel.donutEditor) {
	Label("Donut Editor", systemImage: "slider.horizontal.3")
}.accessibilityIdentifier("donut_editor")
```

Corresponding tap command on maestro side would now look like that:

```yaml
- tapOn:
    id: "donut_editor"
```

Full flow can be found [here](https://github.com/artem888/sample-food-truck/blob/main/.mobiledev/accessibility\_label.yaml).\
\
maestro translates `accessibilityIdentifier` to `id` while `accessibilityLabel` is translated to `text`. When an element has both some text content and `accessibilityLabel` assigned the latter will be picked as a value for `text` by maestro framework.

### System menus / dialogs

[The following flow](https://github.com/artem888/SwiftUI-Kit/blob/master/.mobiledev/buttons.yaml) demonstrates how to interact with different types of native popups / dialogs / context menus etc. To simplify an access to the elements `accessibilityIdentifier` was used again, whenever possible.

### System controls

[The following flow](https://github.com/artem888/SwiftUI-Kit/blob/master/.mobiledev/controls.yaml) demonstrates how to interact with native SwiftUI controls like Toggle, Picker, Segmented Picker. The best practice here is to give unique `accessibilityIdentifier` values to individual elements that represent some value in a list.

### Switching between different apps

Switching between different apps during the same flow is also supported by maestro. [The following flow](https://github.com/artem888/SwiftUI-Kit/blob/master/.mobiledev/link.yaml) opens url in Safari and then returns to the main app (SwiftUI-Kit) that was previously launched.

```yaml
- tapOn:
    id: "breadcrumb"
```

<div align="left">

<figure><img src="../.gitbook/assets/Simulator Screen Shot - iPhone 14 - 2023-01-12 at 22.31.14 (2) (1).png" alt=""><figcaption></figcaption></figure>

</div>

breadcrumb is an accessibility id \
of the “Back to SwiftUI app” \
button on the screenshot below, which was also found with a help of `maestro studio`

### Known issues:

* Hierarchy for some elements is not returned (i.e. **WheelPickerStyle**)
* When **Toggle** is initialized with text, its accessibility element is a union of a text and toggle
* Sometimes only one of accessibilityLabel / accessibilityIdentifier (i.e. **Link**)
* Sometimes List / Group elements are not assigning accessibility ids / labels correctly (i.e `SectionView { Group { Menu } }`)

{% content-ref url="broken-reference" %}
[Broken link](broken-reference)
{% endcontent-ref %}



================================================
FILE: platform-support/ios-uikit.md
================================================
# iOS - UIKit

<figure><img src="../.gitbook/assets/ios.png" alt=""><figcaption></figcaption></figure>

Maestro fully supports native iOS UIKit apps.

## Interacting with views by text

Any view with text content can be tapped on, i.e.:

```swift
let button = UIButton()
button.setTitle("Hello World", for: .normal)
```

Can be tapped in the following way:

```
tapOn: Hello World
```

## Interacting with views by accessibility labels

Views can be accessed by their accessibility labels. For example:

```swift
let button = UIButton()
button.accessibilityLabel = "Hello World button"
```

Can be tapped in the following way:

```
tapOn: Hello World button
```

**NB!** maestro translates `accessibilityIdentifier` to `id` while `accessibilityLabel` is translated to `text`. When an element has both some text content and `accessibilityLabel` assigned the latter will be picked as a value for `text` by maestro framework.

## Interacting with views by accessibility ids

Views can be accessed by their accessibility ids. For example:

```swift
let button = UIButton()
button.accessibilityIdentifier = "hello_world_id"
```

Can be tapped in the following way:

```
- tapOn:
    id: "hello_world_id"
```

{% content-ref url="broken-reference" %}
[Broken link](broken-reference)
{% endcontent-ref %}

### Known Limitations

1. Maestro can't interact with real iOS devices yet. Only Simulator is supported at the moment.



================================================
FILE: platform-support/react-native.md
================================================
# React Native

<figure><img src="../.gitbook/assets/reactnative.png" alt=""><figcaption></figcaption></figure>

Maestro supports testing React Native screens and apps on both Android and iOS.

### Interacting with a component by Text

Maestro can interact with components that display text.

#### Example: Tap on a Button

For the Button component definition:

```dart
<Button
  title="Go"
  onPress={() => Alert.alert('Success!')}
/>
```

The following command will tap on the Button:

```dart
- tapOn: "Go"
```

### Interaction with a component by testID

Maestro can interact with components that have a testID.

#### Example: Tap on a button with a testID property

For the Button component definition:

```dart
<Button
  title="Go"
  testID="continue"
  onPress={() => Alert.alert('Success!')}
/>
```

The following command will tap on the Button:

```dart
- tapOn:
    id: "continue"
```

### Entering text in a Text Input

#### Example: Enter text into a TextInput.

To input text to a TextInput component, first the component needs to be selected. This can be done using the tapOn command. For the component definition:

```dart
<TextInput placeholder="Change me!" />
```

The following commands will enter "Hello, Maestro!" in the TextInput component:

```dart
- tapOn: "Change me!"
- inputText: "Hello, Maestro!"
```

## Create a working sample app with Maestro tests

### Install Maestro

[Maestro install instructions](https://maestro.mobile.dev/getting-started/installing-maestro)

### Create a sample app

Follow the _Expo Go Quickstart_ instructions on [React Native environment setup](https://reactnative.dev/docs/environment-setup)

Replace the contents of App.js with:

```javascript
import React, { useState } from 'react';
import { SafeAreaView, Button, Text, TextInput, StyleSheet } from 'react-native';

export default function App() {
  const [taps, setTaps] = useState(0);
  const [text, setText] = useState('')
  return (
    <SafeAreaView>
      <Button
        title="Add one"
        variant="primary"
        onPress={() => setTaps(taps + 1)}
      />
      <Button
        title="Add ten"
        testID="add_ten"
        onPress={() => setTaps(taps + 10)}
      />
      <Text>Number of taps: {taps}</Text>
      <TextInput
        testID="text_input"
        placeholder="Change me!"
        onChangeText={setText}
      />
      <Text>You typed: {text}</Text>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
```

Create a test definition file called `flow.yaml`

Add the following contents:

```yaml
appId: host.exp.Exponent
---
- launchApp
- tapOn: "Add one"
- tapOn:
    id: "add_ten"
- assertVisible: "Number of taps: 11"
- tapOn: "Change me!"
- inputText: "Hello, Maestro!"
- assertVisible: "You typed: Hello, Maestro!"
```

### Start the app and test using Maestro

Run `npm start` in the react native app source directory

Select either Android or iOS Simulator

In another terminal, run `maestro test flow.yaml`

When the Expo app launches, select the app that you’re testing

### Demo

{% file src="../.gitbook/assets/Screen Recording 2023-01-11 at 21.24.32.mov" %}
React Native app tested using Maestro
{% endfile %}

## Interacting with nested components on iOS

In some cases, you may run into issues with nested tappable / accessible elements on iOS. You can resolve these issues by enabling accessibility for the inner component and disabling it for the outer container.

#### Example: Tapping on nested Text Component

```javascript
<TouchableOpacity 
  style={{ borderWidth: 1, margin: 5, padding: 10, backgroundColor: '#ddd' }} 
   accessible={false}>
  <Text>This is the wrapper button </Text>
  <TouchableOpacity 
    style={{ backgroundColor: 'red', padding: 5, width: '50%', marginTop: 10 }} 
     accessible={true}>
    <Text>I'm a small button</Text>
  </TouchableOpacity>
</TouchableOpacity>
```

&#x20;The following command will tap on the nested Text Component:

```yaml
- tapOn: "I'm a small button"
```

## Resources

* [A great introduction to Maestro with React Native](https://dev.to/b42/test-your-react-native-app-with-maestro-5bfj) by Alexander Hodes
* [E2E testing of React Native apps using EAS and Maestro (Expo documentation)](https://docs.expo.dev/build-reference/e2e-tests/)




================================================
FILE: platform-support/supported-platforms.md
================================================
# Supported Platforms

<figure><img src="../.gitbook/assets/All Banner (5).png" alt=""><figcaption></figcaption></figure>

Maestro supports all of the major mobile development platforms as well as desktop browsers. Check out the guides below to learn how to interact with UI elements on each framework.

<table><thead><tr><th width="572">Platform</th><th align="center">Supported</th></tr></thead><tbody><tr><td><a href="android-views.md">Android - Views</a></td><td align="center">✅</td></tr><tr><td><a href="android-jetpack-compose.md">Android - Jetpack Compose</a></td><td align="center">✅</td></tr><tr><td><a href="ios-uikit.md">iOS - UIKit</a></td><td align="center">✅</td></tr><tr><td><a href="ios-swiftui.md">iOS - SwiftUI</a></td><td align="center">✅</td></tr><tr><td><a href="react-native.md">React Native</a></td><td align="center">✅</td></tr><tr><td><a href="flutter.md">Flutter</a></td><td align="center">✅</td></tr><tr><td><a href="web-views.md">Web Views</a></td><td align="center">✅</td></tr><tr><td><a href="web-desktop-browser.md">Web (Desktop Browser)</a></td><td align="center">✅</td></tr><tr><td>.NET MAUI iOS</td><td align="center">✅</td></tr><tr><td>.NET MAUI Android</td><td align="center">✅</td></tr></tbody></table>



================================================
FILE: platform-support/web-desktop-browser.md
================================================
# Web (Desktop Browser)

<figure><img src="../.gitbook/assets/Chromium Banner (1).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Desktop support is currently in Beta. We would appreciate your feedback!
{% endhint %}

Maestro can test Web apps / web pages running on a desktop browser.

### Example Usage

The syntax is exactly the same as for any other Maestro test, except that you need to specify `url` instead of an `appId` in your test file

```yaml
# example.yaml

url: https://maestro.mobile.dev
---
- launchApp
- tapOn: Installing Maestro
- assertVisible: Installing the CLI
```

Then run it with:

```
maestro test example.yaml
```

{% hint style="info" %}
Maestro will spend some time downloading Chromium on the first launch. Each following test will run much faster.
{% endhint %}

### Maestro Studio

To launch Maestro Studio for Web, use the `-p web` option:

```
maestro -p web studio
```

### Other Resources

{% content-ref url="broken-reference" %}
[Broken link](broken-reference)
{% endcontent-ref %}

{% content-ref url="../api-reference/commands/" %}
[commands](../api-reference/commands/)
{% endcontent-ref %}

### Known Limitations

These features are not supported yet but should be feasible to implement if there is a common demand:

* Different browsers support (current default is Chromium)
* Different locales support (current default is en-US)
* Screen size configuration



================================================
FILE: platform-support/web-views.md
================================================
# Web Views

Maestro supports mobile applications that rely on Web Views, both on Android and iOS, including embedded Web Views as well as standalone browser apps (such as, but not limited to, Safari or Chrome). No special configuration is required.

Maestro can be used to test web applications running on mobile or on a desktop. For more information on desktop support refer to [web-desktop-browser.md](web-desktop-browser.md "mention")

{% content-ref url="broken-reference" %}
[Broken link](broken-reference)
{% endcontent-ref %}



================================================
FILE: troubleshooting/bug-report.md
================================================
# Bug Report

### How to report an issue

If an issue / bug encountered while using Maestro, we encourage you to [create a GitHub issue](https://github.com/mobile-dev-inc/maestro/issues/new/choose).

Please follow the instructions in the issue templates to make our triage process
easier.

### bugreport command

To provide more context, there is a command:

```
maestro bugreport
```

This command collects some data about Maestro usage locally on a user's machine.
This data includes Maestro process logs and system info, such as maestro
version, OS version, and device CPU architecture.

When creating a new issue / bug report in attach the .zip files generated in the
folder specified after running `maestro bugreport` command.



================================================
FILE: troubleshooting/debug-output.md
================================================
# Debug Output

### Command Failure Reason

If a command fails, failure reason will be shown in red at the end.

<figure><img src="../.gitbook/assets/231784307-53c51d7f-214f-4eb4-b9ba-9ec34380d280.png" alt=""><figcaption><p>Single Flow Run Failure</p></figcaption></figure>

<figure><img src="../.gitbook/assets/231784391-31aaf0a1-5b80-4372-a1e6-b2e6642af472 (1).png" alt=""><figcaption><p>Multiple Flow Run Failures</p></figcaption></figure>

### Screenshot On Failure

By default, a screenshot will be generated upon failure under the Maestro directory i.e for Mac it's `~/.maestro/tests/<datetime>/`

<figure><img src="../.gitbook/assets/Screenshot 2023-05-18 at 18.54.16.png" alt=""><figcaption></figcaption></figure>

### Maestro Logs

Each flow run will generate:

* A `maestro.log` file that contains Maestro related logs
* A `commands-*.json` file that contains command metadata

Located under the Maestro directory by default: `~/.maestro/tests/<datetime>/` .&#x20;

You can also configure the default path for debug output by using the `--debug-output <path>` option. Example usage:

```
maestro test --debug-output /path/to/debug/logs
```

{% hint style="info" %}
Device logs are not supported but it's something we plan to add
{% endhint %}

{% hint style="info" %}
Such data will be automatically deleted after 14 days
{% endhint %}



================================================
FILE: troubleshooting/frequently-asked-questions.md
================================================
# Frequently Asked Questions

### How can I use the same flow when my apps have different app IDs?

If you want to run the same flow for apps with different app IDs, you can use an [external parameter](../advanced/parameters-and-constants.md) for `appId`. Pass the parameter `APP_ID` to Maestro:

```
maestro test -e APP_ID=your.app.id file.yaml
```

And then refer to it in your flow using `${APP_ID}`:

```yaml
appId: ${APP_ID}
---
- launchApp
```

### How do I assert on a string that contains a dollar sign?

Values with dollar signs can be interpreted as variables. To avoid this, escape the dollar characters.

```yaml
- assertVisible: \$150 in Cash
```

### How do I compare two values?

To assert on values that exist on different screens, store them in variables.

```yaml
# Perform steps to navigate to first value, then:
- copyTextFrom: 
    id: 'listView1'
- evalScript: ${output.firstPrice = maestro.copiedText}

# Perform steps to navigate to the second value, then:
- copyTextFrom: 
    id: 'detailView'
- evalScript: ${output.secondPrice = maestro.copiedText}

# Compare the values:
- runFlow:
    when:
      true: ${output.firstPrice === output.secondPrice}
    commands:
      - evalScript: ${console.log('Prices match! Both are ' + output.secondPrice)}
```



### How do I generate a random number?

Whilst there are commands for random strings and names, there's no function for generating random numbers. Users can use JavaScript to generate a number in the range they need.

randomNumber.js :

```javascript
// Generate an 8 digit random number
output.randomNumber = Math.floor(Math.random() * 90000000) + 10000000;
```

flow.yaml:

```yaml
- runScript: ../scripts/randomNumber.js
- evalScript: ${EMAIL = "maestro+" + output.randomNumber + "@domain.com"}
```



### Why are my tests slower in Maestro's cloud environment?

The cloud environment optimises for reliability and repeatability, on the belief that slower correct results beat faster inconsistent results, every time. Each device, between one test and the next, is wiped and recreated, so that there's no chance of any test ever affecting any other. Compared with running locally, this adds 2-4 minutes between tests. To improve total time to finish a run, consider adding additional parallel runners. Another option is restructuring your tests for fewer longer tests, but be sure you're not making the same mistake, and sacrificing reliability or information in favour of speed.



================================================
FILE: troubleshooting/known-issues.md
================================================
# Known Issues

## Cross-platform

### App does not launch

Either the app is not installed or the `appId` is wrong. Note that depending on the app type, the identifier can be different.

To find the appID you can perform the following:

On Android:

1. Execute `adb shell pm list packages` to get a list of all installed packages.
2. Search for the appID manually or use `grep` in the above command to search for part of the name: `adb shell pm list packages | grep <name>`

On iOS

1. Execute `xcrun simctl listapps booted | grep CFBundleIdentifier` to get a list of all installed packages
2. Search for the appID manually or use `grep` in the above command to search for part of the name: `xcrun simctl listapps booted | grep CFBundleIdentifier | grep <name>`

## Android

### Text input is not supported for unicode

Unfortunately, Maestro does not yet have Android support of `inputText` commands that have unicode characters in them (follow [this GitHub issue](https://github.com/mobile-dev-inc/maestro/issues/146) for status updates). Only ASCII characters are supported

### Accidental double tap

Sometimes, tapOn will try to tap again if it doesn't detect a hierarchy change. To fix such cases, use `retryTapIfNoChange`. For example:

```
- tapOn:
    text: "Some Button"
    retryTapIfNoChange: false
```

### Unable to clear state

When running tests against a real device you may receive an error of `(Unable to clear state for app <package>)` when running either:

```yaml
- clearState
```

or:

```yaml
- launchApp:
    clearState: true
```

This error is common on physical devices by Oppo. The workaround is to return to the Developer Settings where ADB Debugging was enabled, and disable 'Verify apps over USB'. Some users have reported needing to enable "Disable permission monitoring" too.

## iOS

### `hideKeyboard` command is flaky

On iOS, `hideKeyboard` is done with the help of scrolling up and down from the middle of the screen since there is no native API to hide the keyboard.

If using this command doesn't hide the keyboard we recommend clicking on some non-tappable region with `tapOn` points command, similar to how a user would hide the keyboard when interacting with your app.

### Issues with lists (UICollectionView, UITableView) that fetch data on scroll

Apps that have pagination (fetch data on scroll) inside UITableView / UICollectionView views sometimes result in fetching data at the moments when it is not expected, hanging inside the lists, and flows being broken when testing with Maestro.

There is a bug in XCTest framework that makes UITableView / UICollectionView `willDisplayCell` method being called whenever UI test APIs are being called. Since Maestro relies on XCTest APIs under the hood it might break the pagination logic for some apps.

#### Suggested workaround

Inside `willDisplayCell` check whether the indexPath is really visible via `UITableView.indexPathsForVisibleRows` or `UICollectionView.indexPathsForVisibleItems`:

```swift
// This function should be implemented in a class conforming to UITableViewDelegate
// in case of UICollectionView `collectionView(_:willDisplay:forItemAt:)` from
// UICollectionViewDelegate should be used
func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
  // additional check whether the cell is currently visible or not is needed
  // to make sure calls caused by XCTest or other random tableView reloads
  // do not unintentional data fetch request
  guard let visibleIndexPaths = tableView.indexPathsForVisibleRows,
            visibleIndexPaths.contains(indexPath),
            <additional checks that were previosly there> else { return }
        
  print("load new data..")
}
```



================================================
FILE: troubleshooting/rollback-maestro.md
================================================
---
description: A guide to install previous Maestro version
---

# Rollback Maestro

There are some situations where a user needs to roll-back to a previous version of Maestro. Reasons can be some issue introduced in recent version or some support got removed. In those cases, a user can follow below steps to roll the Maestro back to previous version and continue using it.

To do that, you can install a specific Maestro version using the steps described [here](https://maestro.mobile.dev/getting-started/installing-maestro#installing-a-specific-version-of-maestro).



================================================
FILE: troubleshooting/howtos/README.md
================================================
# HOWTOs




================================================
FILE: troubleshooting/howtos/scrolluntilvisible-for-fragments.md
================================================
# scrollUntilVisible for fragments

Our friends at Amicara hit a problem with their app that Maestro couldn't natively solve. They wanted to use `scrollUntilVisible`, but it wasn't working for them.

Now, under the hood, scrollUntilVisible works like this:

1. Checks for the visibility of the element described by the selector
2. Swipe up from the center of the screen
3. Go to step 1

Now, in Amicara's app, scrolling from the middle wouldn't work - only the bottom half of the app had scrollable elements.

<figure><img src="../../.gitbook/assets/image (8).png" alt="" width="375"><figcaption></figcaption></figure>

Working with their test developers and other folks in the community, we developed a new version of scrollUntilVisible through native Maestro commands.



```yaml
- evalScript: ${output.foundElement = 0}

# Check if it's already visible
- runFlow:
    when:
      visible:
        id: "the_thing_we_want"
    commands:
      - evalScript: ${output.foundElement = 1}

# Loop until found
- repeat:
    while:
      true: ${output.foundElement == 0}
    commands:
      # Swipe up, from 90% down the screen to 75% down the screen
      - swipe:
          start: 50%, 90%
          end: 50%, 75%
      # Check if it's visible yet
      - runFlow:
          when:
            visible:
              id: "the_thing_we_want"
          commands:
            - evalScript: ${output.foundElement = 1}
```



