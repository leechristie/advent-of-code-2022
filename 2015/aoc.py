# Data Loading Methods

def load_single_line(filename: str) -> str:
    with open(filename) as file:
        return next(file).strip()
