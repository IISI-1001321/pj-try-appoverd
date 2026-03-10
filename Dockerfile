# ── Stage 1: Build ──────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /workspace

# 先複製 pom.xml，利用 Docker layer cache 加速相依套件下載
COPY pom.xml .
RUN mvn dependency:go-offline -B 2>/dev/null || true

# 複製原始碼並打包（跳過測試，測試由 CI 負責）
COPY src/ src/
RUN mvn package -DskipTests -B

# ── Stage 2: Runtime ─────────────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine AS runtime

# 建立非 root 使用者，避免以 root 執行容器
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# 從 builder stage 複製打包後的 jar
COPY --from=builder /workspace/target/*.jar app.jar

# 切換至非 root 使用者
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
