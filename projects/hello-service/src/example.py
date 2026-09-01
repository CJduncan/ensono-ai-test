"""A tiny example so CI has something real to run. Replace freely."""


def greet(name: str) -> str:
    name = name.strip() or "world"
    return f"Hello, {name}!"
