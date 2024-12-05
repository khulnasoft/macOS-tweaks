/*
    Constants.h
    Copyright 2024 KhulnaSoft, Ltd
     
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
     
    http://www.apache.org/licenses/LICENSE-2.0
     
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#define kMTAppName                              @"Privileges"
#define kMTDaemonMachServiceName                @"com.khulnasoft.privileges.daemon.xpc"
#define kMTAgentMachServiceName                 @"com.khulnasoft.privileges.agent.xpc"
#define kMTXPCServiceName                       @"com.khulnasoft.privileges.xpcservice"
#define kMTAppBundleIdentifier                  @"com.khulnasoft.privileges"
#define kMTAppGroupIdentifier                   @"7R5ZEU67FQ.com.khulnasoft.privileges"
#define kMTErrorDomain                          @"com.khulnasoft.privileges.ErrorDomain"
#define kMTGitHubURL                            @"https://github.com/KHULNASOFT/MacOS-Privileges"

#define kMTAdminGroupID                         80
#define kMTExpirationDefault                    20
#define kMTReasonMinLengthDefault               10
#define kMTReasonMaxLengthDefault               250
#define kMTFixedExpirationIntervals             @[@0, @5, @10, @20, @30, @60]
#define kMTRevokeAtLoginThreshold               60

#define kMTEnforcedPrivilegeTypeNone            @"none"
#define kMTEnforcedPrivilegeTypeAdmin           @"admin"
#define kMTEnforcedPrivilegeTypeUser            @"user"

#define kMTRemoteLoggingServerTypeSyslog        @"syslog"
#define kMTRemoteLoggingServerTypeWebhook       @"webhook"

// NSUserDefaults
#define kMTDefaultsExpirationIntervalKey            @"ExpirationInterval"
#define kMTDefaultsAutoExpirationIntervalMaxKey     @"ExpirationIntervalMax"
#define kMTDefaultsEnforcePrivilegesKey             @"EnforcePrivileges"
#define kMTDefaultsAuthRequiredKey                  @"RequireAuthentication"
#define kMTDefaultsAuthCLIBiometricsAllowedKey      @"AllowCLIBiometricAuthentication"
#define kMTDefaultsLimitToUserKey                   @"LimitToUser"
#define kMTDefaultsLimitToGroupKey                  @"LimitToGroup"
#define kMTDefaultsRequireReasonKey                 @"ReasonRequired"
#define kMTDefaultsReasonMinLengthKey               @"ReasonMinLength"
#define kMTDefaultsReasonMaxLengthKey               @"ReasonMaxLength"
#define kMTDefaultsReasonPresetsKey                 @"ReasonPresetList"
#define kMTDefaultsReasonCheckingEnabledKey         @"ReasonCheckingEnabled"
#define kMTDefaultsRemoteLoggingKey                 @"RemoteLogging"
#define kMTDefaultsRemoteLoggingServerTypeKey       @"ServerType"
#define kMTDefaultsRemoteLoggingServerAddressKey    @"ServerAddress"
#define kMTDefaultsRemoteLoggingSyslogOptionsKey    @"SyslogOptions"
#define kMTDefaultsRemoteLoggingSyslogServerPortKey @"ServerPort"
#define kMTDefaultsRemoteLoggingSyslogUseTLSKey     @"UseTLS"
#define kMTDefaultsRemoteLoggingSyslogFacilityKey   @"LogFacility"
#define kMTDefaultsRemoteLoggingSyslogSeverityKey   @"LogSeverity"
#define kMTDefaultsRemoteLoggingSyslogMaxSizeKey    @"MaximumMessageSize"
#define kMTDefaultsHideOtherWindowsKey              @"HideOtherWindows"
#define kMTDefaultsRevokeAtLoginKey                 @"RevokePrivilegesAtLogin"
#define kMTDefaultsPostChangeExecutablePathKey      @"PostChangeExecutablePath"
#define kMTDefaultsPostChangeActionOnGrantOnlyKey   @"PostChangeActionOnGrantOnly"
#define kMTDefaultsAgentTimerExpirationKey          @"TimerExpires"
#define kMTDefaultsUnhideOtherWindowsKey            @"UnhideOtherWindows"
#define kMTDefaultsHideSettingsButtonKey            @"HideSettingsButton"
#define kMTDefaultsHideSettingsFromDockMenuKey      @"HideSettingsFromDockMenu"

// NSNotification
#define kMTNotificationNamePrivilegesDidChange  @"com.khulnasoft.privileges.PrivilegesDidChange"
#define kMTNotificationNameExpirationTimeLeft   @"com.khulnasoft.privileges.ExpirationTimeLeft"
#define kMTNotificationNameConfigDidChange      @"com.khulnasoft.privileges.ConfigDidChange"

// NSNotification user info keys
#define kMTNotificationKeyTimeLeft              @"TimeLeft"
#define kMTNotificationKeyPreferencesChanged    @"PreferenceKey"
