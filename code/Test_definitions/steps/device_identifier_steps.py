from behave import given, when, then

@given("a mobile subscriber")
def step_given(context):
    context.subscriber = "example_subscriber"

@when("the API is called")
def step_when(context):
    context.response = {"IMEI": "123456789012345"}

@then("the response contains the IMEI")
def step_then(context):
    assert "IMEI" in context.response
