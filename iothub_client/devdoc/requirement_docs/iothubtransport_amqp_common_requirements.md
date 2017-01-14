
# IoTHubTransport_AMQP_Common Requirements
================

## Overview

This module provides an implementation of the transport layer of the IoT Hub client based on the AMQP API, which implements the AMQP protocol.  
It is the base for the implentation of the actual respective AMQP transports, which will on their side provide the underlying I/O transport for this module.


## Exposed API

```c
typedef XIO_HANDLE(*AMQP_GET_IO_TRANSPORT)(const char* target_fqdn);

extern TRANSPORT_LL_HANDLE IoTHubTransport_AMQP_Common_Create(const IOTHUBTRANSPORT_CONFIG* config, AMQP_GET_IO_TRANSPORT get_io_transport);
extern void IoTHubTransport_AMQP_Common_Destroy(TRANSPORT_LL_HANDLE handle);
extern int IoTHubTransport_AMQP_Common_Subscribe(IOTHUB_DEVICE_HANDLE handle);
extern void IoTHubTransport_AMQP_Common_Unsubscribe(IOTHUB_DEVICE_HANDLE handle);
extern int IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle);
extern void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle);
extern int IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle);
extern void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle);
extern IOTHUB_PROCESS_ITEM_RESULT IoTHubTransport_AMQP_Common_ProcessItem(TRANSPORT_LL_HANDLE handle, IOTHUB_IDENTITY_TYPE item_type, IOTHUB_IDENTITY_INFO* iothub_item);
extern void IoTHubTransport_AMQP_Common_DoWork(TRANSPORT_LL_HANDLE handle, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle);
extern IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_GetSendStatus(IOTHUB_DEVICE_HANDLE handle, IOTHUB_CLIENT_STATUS* iotHubClientStatus);
extern IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_SetOption(TRANSPORT_LL_HANDLE handle, const char* option, const void* value);
extern IOTHUB_DEVICE_HANDLE IoTHubTransport_AMQP_Common_Register(TRANSPORT_LL_HANDLE handle, const IOTHUB_DEVICE_CONFIG* device, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle, PDLIST_ENTRY waitingToSend);
extern void IoTHubTransport_AMQP_Common_Unregister(IOTHUB_DEVICE_HANDLE deviceHandle);
extern STRING_HANDLE IoTHubTransport_AMQP_Common_GetHostname(TRANSPORT_LL_HANDLE handle);

```


Note: `instance` refers to the structure that holds the current state and control parameters of the transport. 
In each function (other than IoTHubTransport_AMQP_Common_Create) it shall derive from the TRANSPORT_LL_HANDLE handle passed as argument.  


### IoTHubTransport_AMQP_Common_GetHostname
```c
 STRING_HANDLE IoTHubTransport_AMQP_Common_GetHostname(TRANSPORT_LL_HANDLE handle)
```

IoTHubTransport_AMQP_Common_GetHostname provides a STRING_HANDLE containing the hostname with which the transport has been created.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_001: [**If `handle` is NULL, `IoTHubTransport_AMQP_Common_GetHostname` shall return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_002: [**IoTHubTransport_AMQP_Common_GetHostname shall return a copy of `instance->iothub_target_fqdn`.**]**


### IoTHubTransport_AMQP_Common_Create

```c
TRANSPORT_LL_HANDLE IoTHubTransport_AMQP_Common_Create(const IOTHUBTRANSPORT_CONFIG* config, AMQP_GET_IO_TRANSPORT get_io_transport)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_005: [**If `config` or `config->upperConfig` are NULL then IoTHubTransport_AMQP_Common_Create shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_006: [**IoTHubTransport_AMQP_Common_Create shall fail and return NULL if any fields of the `config->upperConfig` structure are NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_254: [**If `get_io_transport` is NULL then IoTHubTransport_AMQP_Common_Create shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_009: [**IoTHubTransport_AMQP_Common_Create shall allocate memory for the transport's internal state structure (`instance`) using malloc()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_009: [**If malloc() fails, IoTHubTransport_AMQP_Common_Create shall fail and return NULL**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_010: [**If `config->upperConfig->protocolGatewayHostName` is NULL, `instance->iothub_target_fqdn` shall be set using STRING_sprintf() with `config->iotHubName` + "." + `config->iotHubSuffix`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_20_001: [**If STRING_sprintf() fails, IoTHubTransport_AMQP_Common_Create shall fail and return NULL**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_20_001: [**If `config->upperConfig->protocolGatewayHostName` is not NULL, `instance->iothub_target_fqdn` shall be set with a copy of it using STRING_construct()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_20_001: [**If STRING_construct() fails, IoTHubTransport_AMQP_Common_Create shall fail and return NULL**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_218: [**IoTHubTransport_AMQP_Common_Create shall set `instance->registered_devices` using VECTOR_create()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_219: [**If VECTOR_create fails, IoTHubTransport_AMQP_Common_Create shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_236: [**If IoTHubTransport_AMQP_Common_Create fails it shall free any memory it allocated**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_023: [**If IoTHubTransport_AMQP_Common_Create succeeds it shall return a pointer to `instance`.**]**
  
 
### IoTHubTransport_AMQP_Common_Destroy

```c
void IoTHubTransport_AMQP_Common_Destroy(TRANSPORT_LL_HANDLE handle)
```

This function will close connection established through AMQP API, as well as destroy all the components allocated internally for its proper functionality.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_209: [**IoTHubTransport_AMQP_Common_Destroy shall invoke IoTHubTransport_AMQP_Common_Unregister on each of its registered devices.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_210: [**`instance->registered_devices` shall be destroyed using VECTOR_destroy().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_212: [**`instance->connection` shall be destroyed using amqp_connection_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_212: [**IoTHubTransport_AMQP_Common_Destroy shall destroy the STRING_HANDLE parameters in `instance` using STRING_delete()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_213: [**IoTHubTransport_AMQP_Common_Destroy shall destroy any TLS I/O options saved on the transport instance using OptionHandler_Destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_150: [**IoTHubTransport_AMQP_Common_Destroy shall free the memory used by `instance`**]**


### IoTHubTransport_AMQP_Common_DoWork

```c
void IoTHubTransport_AMQP_Common_DoWork(TRANSPORT_LL_HANDLE handle, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle)
```  

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_051: [**If `handle` is NULL, IoTHubTransport_AMQP_Common_DoWork shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_237: [**If there are no devices registered on the transport, IoTHubTransport_AMQP_Common_DoWork shall return**]**

TODO: rework this:
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_238: [**If the transport state has a faulty connection state, IoTHubTransport_AMQP_Common_DoWork shall trigger the connection-retry logic**]**


#### Connection Establishment

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_055: [**If `transport->connection` is NULL, it shall be created using amqp_connection_create()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_055: [**If `transport->preferred_authentication_method` is CBS, AMQP_CONNECTION_CONFIG shall be set with `create_sasl_io` = true and `create_cbs_connection` = true**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_055: [**If `transport->preferred_credential_method` is X509, AMQP_CONNECTION_CONFIG shall be set with `create_sasl_io` = false and `create_cbs_connection` = false**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_200: [**`instance->logtrace` shall be set into `AMQP_CONNECTION_CONFIG->logtrace`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_055: [**If amqp_connection_create() fails, IoTHubTransport_AMQP_Common_DoWork shall return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_241: [**IoTHubTransport_AMQP_Common_DoWork shall iterate through all its registered devices to process authentication, events to be sent, messages to be received**]**


#### Per-Device DoWork Requirements

##### Authentication


**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If `device_instance->authentication` is not NULL and `device_instance->authentication_state` is AUTHENTICATION_STATE_STOPPED, authentication_start() shall be invoked**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**amqp_connection_get_cbs_handle() shall be invoked on `instance->connection`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If amqp_connection_get_cbs_handle() fails, IoTHubTransport_AMQP_Common_DoWork shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**authentication_start() shall be invoked passing the CBS_HANDLE obtained from the connection**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If authentication_start() fails, IoTHubTransport_AMQP_Common_DoWork shall skip to the next registered device**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If `device_instance->authentication` is not NULL, authentication_do_work() shall be invoked**]**

##### Messaging

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If `device_instance->authentication` is not NULL and `device_instance->authentication_state` is not AUTHENTICATION_STATE_STARTED, IoTHubTransport_AMQP_Common_DoWork shall skip to the next registered device**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If `device_instance->messenger_state` is MESSENGER_STATE_STOPPED, messenger_start() shall be invoked**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**amqp_connection_get_session_handle() shall be invoked on `instance->connection`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If amqp_connection_get_session_handle() fails, IoTHubTransport_AMQP_Common_DoWork shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**messenger_start() shall be invoked passing the SESSION_HANDLE obtained from the connection**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_243: [**If `device_instance->messenger_state` is MESSENGER_STATE_STARTED, messenger_do_work() shall be invoked**]**

  
##### Sending Events

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_245: [**IoTHubTransport_AMQP_Common_DoWork shall skip sending events if the state of the message_sender is not MESSAGE_SENDER_STATE_OPEN**]**

Note: 
SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_245 is specially important for device multiplexing scenarios.
On a given connection, there must not be messages sent to the Hub before the device has been authenticated, despite if other multiplexed devices have already been authenticated on such connection.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_086: [**IoTHubTransport_AMQP_Common_DoWork shall move queued events to an "in-progress" list right before processing them for sending**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_193: [**IoTHubTransport_AMQP_Common_DoWork shall get a MESSAGE_HANDLE instance out of the event's IOTHUB_MESSAGE_HANDLE instance by using message_create_from_iothub_message().**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_111: [**If message_create_from_iothub_message() fails, IoTHubTransport_AMQP_Common_DoWork notify the failure, roll back the event to waitToSend list and return**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_097: [**IoTHubTransport_AMQP_Common_DoWork shall pass the MESSAGE_HANDLE intance to uAMQP for sending (along with on_message_send_complete callback) using messagesender_send()**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_113: [**If messagesender_send() fails, IoTHubTransport_AMQP_Common_DoWork notify the failure, roll back the event to waitToSend list and return**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_194: [**IoTHubTransport_AMQP_Common_DoWork shall destroy the MESSAGE_HANDLE instance after messagesender_send() is invoked.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_100: [**The callback 'on_message_send_complete' shall remove the target message from the in-progress list after the upper layer callback**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_142: [**The callback 'on_message_send_complete' shall pass to the upper layer callback an IOTHUB_CLIENT_CONFIRMATION_OK if the result received is MESSAGE_SEND_OK**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_143: [**The callback 'on_message_send_complete' shall pass to the upper layer callback an IOTHUB_CLIENT_CONFIRMATION_ERROR if the result received is MESSAGE_SEND_ERROR**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_102: [**The callback 'on_message_send_complete' shall invoke the upper layer callback for message received if provided**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_151: [**The callback 'on_message_send_complete' shall destroy the message handle (IOTHUB_MESSAGE_HANDLE) using IoTHubMessage_Destroy()**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_152: [**The callback 'on_message_send_complete' shall destroy the IOTHUB_MESSAGE_LIST instance**]**
  

#### General

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_103: [**IoTHubTransport_AMQP_Common_DoWork shall invoke connection_dowork() on AMQP for triggering sending and receiving messages**]**


### IoTHubTransport_AMQP_Common_Register

```c
IOTHUB_DEVICE_HANDLE IoTHubTransport_AMQP_Common_Register(TRANSPORT_LL_HANDLE handle, const IOTHUB_DEVICE_CONFIG* device, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle, PDLIST_ENTRY waitingToSend)
```

This function registers a device with the transport.  The AMQP transport only supports a single device established on create, so this function will prevent multiple devices from being registered.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_17_005: [**IoTHubTransport_AMQP_Common_Register shall return NULL if the `handle` is NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_17_001: [**IoTHubTransport_AMQP_Common_Register shall return NULL if `device` or `waitingToSend` are NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_220: [**IoTHubTransport_AMQP_Common_Register shall fail and return NULL if the `iotHubClientHandle` is NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_03_002: [**IoTHubTransport_AMQP_Common_Register shall return NULL if `device->deviceId` is NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_221: [**IoTHubTransport_AMQP_Common_Register shall fail and return NULL if the device is not using an authentication mode compatible with the currently used by the transport.**]**

Note: There should be no devices using different authentication modes registered on the transport at the same time (i.e., either all registered devices use CBS authentication, or all use x509 certificate authentication). 

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_222: [**If a device matching the deviceId provided is already registered, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_223: [**IoTHubTransport_AMQP_Common_Register shall allocate an instance of AMQP_TRANSPORT_DEVICE_STATE to store the state of the new registered device.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_224: [**If malloc fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**

Note: the instance of AMQP_TRANSPORT_DEVICE_STATE will be referred below as `device_instance`.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_225: [**IoTHubTransport_AMQP_Common_Register shall save the handle references to the IoTHubClient, transport, waitingToSend list on `device_instance`.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_227: [**A copy of `config->deviceId` shall be saved into `device_state->device_id`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_228: [**If STRING_construct() fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_229: [**If the transport is using CBS authentication, an authentication state shall be created with authentication_create() and stored in `device_instance->authentication`.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_230: [**If authentication_create() fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_229: [**`device_instance->messenger` shall be set using messenger_create().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_230: [**If messenger_create() fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_010: [** `IoTHubTransport_AMQP_Common_Register` shall create a new iothubtransportamqp_methods instance by calling `iothubtransportamqp_methods_create` while passing to it the the fully qualified domain name and the device Id. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_011: [** If `iothubtransportamqp_methods_create` fails, `IoTHubTransport_AMQP_Common_Register` shall fail and return NULL. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_231: [**IoTHubTransport_AMQP_Common_Register shall add the device to `instance->registered_devices` using VECTOR_push_back().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_232: [**If VECTOR_push_back() fails to add the new registered device, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_234: [**If the device is the first being registered on the transport, IoTHubTransport_AMQP_Common_Register shall save its authentication mode as the transport preferred authentication mode.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_233: [**If IoTHubTransport_AMQP_Common_Register fails, it shall free all memory it alloacated.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_233: [**IoTHubTransport_AMQP_Common_Register shall return a handle to `device_instance` as a IOTHUB_DEVICE_HANDLE.**]**


### IoTHubTransport_AMQP_Common_Unregister

```c
void IoTHubTransport_AMQP_Common_Unregister(IOTHUB_DEVICE_HANDLE deviceHandle)
```

This function is intended to remove a device if it is registered with the transport.  

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_214: [**if `deviceHandle` provided is NULL, IoTHubTransport_AMQP_Common_Unregister shall fail and return.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_215: [**if `deviceHandle` has a NULL reference to its transport instance, IoTHubTransport_AMQP_Common_Unregister shall fail and return.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_216: [**If the device is not registered with this transport, IoTHubTransport_AMQP_Common_Unregister shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_035: [**`device_state->messenger` shall be destroyed using messenger_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_217: [**If `device_instance->authentication` is set, it shall be destroyed using authentication_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_012: [**IoTHubTransport_AMQP_Common_Unregister shall destroy the C2D methods handler by calling iothubtransportamqp_methods_destroy**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_217: [**`device_instance->authentication` is set, it shall be destroyed using authentication_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_197: [**`device_instance` shall be removed from `instance->registered_devices` using VECTOR_erase().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_197: [**`device_state->device_id` shall be destroyed using STRING_delete()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_219: [**IoTHubTransport_AMQP_Common_Unregister shall free the memory allocated for the `device_instance`**]**


### IoTHubTransport_AMQP_Common_Subscribe

```c
int IoTHubTransport_AMQP_Common_Subscribe(IOTHUB_DEVICE_HANDLE handle)
```

This function enables the transport to notify the upper client layer of new messages received from the cloud to the device.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_037: [**If `handle` is NULL, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_037: [**If `device_instance` is not registered, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_038: [**messenger_subscribe_for_messages() shall be invoked passing `device_instance->messenger` and `on_message_received_callback`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_038: [**If messenger_subscribe_for_messages() fails, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_038: [**If no failures occur, IoTHubTransport_AMQP_Common_Subscribe shall return 0**]**


#### on_message_received_callback

````c
MESSENGER_DISPOSITION_RESULT on_message_received_callback(IOTHUB_MESSAGE_HANDLE message, void* context)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_104: [**IoTHubClient_LL_MessageCallback() shall be invoked passing the client and the incoming message handles as parameters**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_197: [**The IOTHUB_MESSAGE_HANDLE instance shall be destroyed after invoking IoTHubClient_LL_MessageCallback().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_105: [**on_message_received_callback shall return the result of messaging_delivery_accepted() if the IoTHubClient_LL_MessageCallback() returns IOTHUBMESSAGE_ACCEPTED**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_106: [**on_message_received_callback shall return the result of messaging_delivery_released() if the IoTHubClient_LL_MessageCallback() returns IOTHUBMESSAGE_ABANDONED**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_107: [**on_message_received_callback shall return the result of messaging_delivery_rejected("Rejected by application", "Rejected by application") if the IoTHubClient_LL_MessageCallback() returns IOTHUBMESSAGE_REJECTED**]**


### IoTHubTransport_AMQP_Common_Unsubscribe

```c
void IoTHubTransport_AMQP_Common_Unsubscribe(IOTHUB_DEVICE_HANDLE handle)
```

This function disables the notifications to the upper client layer of new messages received from the cloud to the device.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_039: [**If `handle` is NULL, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_040: [**If `device_state` is not registered, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_038: [**messenger_unsubscribe_for_messages() shall be invoked passing `device_instance->messenger`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_038: [**If messenger_unsubscribe_for_messages() fails, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_038: [**If no failures occur, IoTHubTransport_AMQP_Common_Unsubscribe shall return 0**]**

  
### IoTHubTransport_AMQP_Common_GetSendStatus

```c
IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_GetSendStatus(IOTHUB_DEVICE_HANDLE handle, IOTHUB_CLIENT_STATUS *iotHubClientStatus)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_041: [**If `handle` or `iotHubClientStatus` are NULL, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_INVALID_ARG**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_042: [**IoTHubTransport_AMQP_Common_GetSendStatus shall invoke messenger_get_send_status() passing `device_instance->messenger`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_043: [**If messenger_get_send_status() fails, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_INVALID_ARG**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_043: [**If messenger_get_send_status() returns MESSENGER_IDLE, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_OK and status IOTHUB_CLIENT_SEND_STATUS_IDLE**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_043: [**If messenger_get_send_status() returns MESSENGER_BUSY, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_OK and status IOTHUB_CLIENT_SEND_STATUS_BUSY**]**

  
### IoTHubTransport_AMQP_Common_SetOption

```c
IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_SetOption(TRANSPORT_LL_HANDLE handle, const char* option, const void* value)
```

Summary of options:

|Parameter              |Possible Values               |Details                                          |
|-----------------------|------------------------------|-------------------------------------------------|
|TrustedCerts           |                              |Sets the certificate to be used by the transport.|
|sas_token_lifetime     | 0 to TIME_MAX (milliseconds) |Default: 3600000 milliseconds (1 hour)	How long a SAS token created by the transport is valid, in milliseconds.|
|sas_token_refresh_time | 0 to TIME_MAX (milliseconds) |Default: sas_token_lifetime/2	Maximum period of time for the transport to wait before refreshing the SAS token it created previously.|
|cbs_request_timeout    | 1 to TIME_MAX (milliseconds) |Default: 30 millisecond	Maximum time the transport waits for AMQP cbs_put_token() to complete before marking it a failure.|
|x509certificate        | const char*                  |Default: NONE. An x509 certificate in PEM format |
|x509privatekey         | const char*                  |Default: NONE. An x509 RSA private key in PEM format|
|logtrace               | true or false                |Default: false|


**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_044: [**If handle parameter is NULL then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_045: [**If parameter optionName is NULL then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_046: [**If parameter value is NULL then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG.**]**


The following requirements only apply if the authentication is NOT x509:

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_048: [**IoTHubTransport_AMQP_Common_SetOption shall save and apply the value if the option name is "sas_token_lifetime", returning IOTHUB_CLIENT_OK**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_049: [**IoTHubTransport_AMQP_Common_SetOption shall save and apply the value if the option name is "sas_token_refresh_time", returning IOTHUB_CLIENT_OK**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_148: [**IoTHubTransport_AMQP_Common_SetOption shall save and apply the value if the option name is "cbs_request_timeout", returning IOTHUB_CLIENT_OK**]**


The following requirements only apply to x509 authentication:

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_007: [** If `optionName` is `x509certificate` and the authentication method is not x509 then `IoTHubTransport_AMQP_Common_SetOption` shall return IOTHUB_CLIENT_INVALID_ARG. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_008: [** If `optionName` is `x509privatekey` and the authentication method is not x509 then `IoTHubTransport_AMQP_Common_SetOption` shall return IOTHUB_CLIENT_INVALID_ARG. **]**


The remaining requirements apply independent of the authentication mode:

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_198: [**If `optionName` is `logtrace`, IoTHubTransport_AMQP_Common_SetOption shall save the value on the transport instance.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_202: [**If `optionName` is `logtrace`, IoTHubTransport_AMQP_Common_SetOption shall apply it using connection_set_trace() to current connection instance if it exists and return IOTHUB_CLIENT_OK.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_203: [**If `optionName` is `logtrace`, IoTHubTransport_AMQP_Common_SetOption shall apply it using xio_setoption() to current SASL IO instance if it exists.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_204: [**If xio_setoption() fails, IoTHubTransport_AMQP_Common_SetOption shall fail and return IOTHUB_CLIENT_ERROR.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_205: [**If xio_setoption() succeeds, IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_OK.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_047: [**If the option name does not match one of the options handled by this module, IoTHubTransport_AMQP_Common_SetOption shall pass the value and name to the XIO using xio_setoption().**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_206: [**If the TLS IO does not exist, IoTHubTransport_AMQP_Common_SetOption shall create it and save it on the transport instance.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_207: [**If IoTHubTransport_AMQP_Common_SetOption fails creating the TLS IO instance, it shall fail and return IOTHUB_CLIENT_ERROR.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_208: [**When a new TLS IO instance is created, IoTHubTransport_AMQP_Common_SetOption shall apply the TLS I/O Options with OptionHandler_FeedOptions() if it is has any saved.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_03_001: [**If xio_setoption fails,  IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_ERROR.**]**

### IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin
```c
int IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle, IOTHUB_DEVICE_TWIN_STATE subscribe_state)
```

`IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin` subscribes to DeviceTwin's messages. Not implemented at the moment.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_009: [** `IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin` shall return a non-zero value. **]**

### IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin
```c
void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle, IOTHUB_DEVICE_TWIN_STATE subscribe_state)
```

`IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin` unsubscribes from DeviceTwin's messages. Not implemented.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_010: [** `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin` shall return. **]**


### IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod
```c
int IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_026: [** `IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod` shall remember that a subscribe is to be performed in the next call to DoWork and on success it shall return 0. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_004: [** If `handle` is NULL, `IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod` shall fail and return a non-zero value. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_005: [** If the transport is already subscribed to receive C2D method requests, `IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod` shall perform no additional action and return 0. **]**

### IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod
```c
void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_006: [** If `handle` is NULL, `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod` shall do nothing. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_007: [** `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod` shall unsubscribe from receiving C2D method requests by calling `iothubtransportamqp_methods_unsubscribe`. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_008: [** If the transport is not subscribed to receive C2D method requests then `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod` shall do nothing. **]**

### on_methods_request_received

```c
void on_methods_request_received(void* context, const char* method_name, const unsigned char* request, size_t request_size, IOTHUBTRANSPORT_AMQP_METHOD_HANDLE method_handle);
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_016: [** `on_methods_request_received` shall create a BUFFER_HANDLE by calling `BUFFER_new`. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_028: [** On success, `on_methods_request_received` shall return 0. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_025: [** If creating the buffer fails, on_methods_request_received shall fail and return a non-zero value. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_017: [** `on_methods_request_received` shall call the `IoTHubClient_LL_DeviceMethodComplete` passing the method name, request buffer and size and the newly created BUFFER handle. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_019: [** `on_methods_request_received` shall call `iothubtransportamqp_methods_respond` passing to it the `method_handle` argument, the response bytes, response size and the status code. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_020: [** The response bytes shall be obtained by calling `BUFFER_u_char`. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_021: [** The response size shall be obtained by calling `BUFFER_length`. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_022: [** The status code shall be the return value of the call to `IoTHubClient_LL_DeviceMethodComplete`. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_023: [** After calling `iothubtransportamqp_methods_respond`, the allocated buffer shall be freed by using BUFFER_delete. **]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_029: [** If `iothubtransportamqp_methods_respond` fails, `on_methods_request_received` shall return a non-zero value. **]**

###on_methods_error

```c
void on_methods_error(void* context)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_030: [** `on_methods_error` shall do nothing. **]**