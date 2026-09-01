from src.example import greet


def test_greet_name():
    assert greet("Connor") == "Hello, Connor!"


def test_greet_empty_defaults_to_world():
    assert greet("   ") == "Hello, world!"
