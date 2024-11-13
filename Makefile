# Define ANSI color codes
GREEN  = \033[0;32m
YELLOW = \033[0;33m
NC     = \033[0m

# Python virtual environment setup
create_venv:
	python3.13 -m venv venv

# Install dependencies
install:
	pip install --upgrade pip && \
 	pip install -r src/requirements.txt && \
 	pip install -r tests/requirements.txt && \
 	pip install -r requirements-dev.txt


# Linting
lint:
	ruff check src && ruff check tests

# Format code
format:
	ruff format src && ruff format tests

# Run tests
test:
	ruff check src && ruff check tests && pytest tests/unit -n 3 -v --cov=src --cov-report=term-missing --cov-fail-under=99

integration:
	pytest tests/integration -v || pytest --last-failed -v

# Pre-commit hooks
pre-commit:
	@echo "$(YELLOW)Running pre-commit tasks...$(NC)"
	@make format
	@make test
	@make integration
	@echo "$(GREEN)Pre-commit tasks: OK$(NC)"

# Generate coverage report
coverage:
	pytest tests/unit -n 3 --cov=src --cov-report=html && \
	if [ "$$(uname)" = "Darwin" ]; then \
		open htmlcov/index.html; \
	elif [ "$$(uname)" = "Windows" ]; then \
		start htmlcov\\index.html; \
	fi

db:
	docker-compose up -d
	alembic upgrade head


# LocalStack setup
localstack:
	docker stop localstack || true
	docker rm localstack || true
	docker run -d -p 4566:4566 --name localstack -it localstack/localstack
	#Create AWS local resources
	chmod +x ./localstack-resources.sh
	./localstack-resources.sh
