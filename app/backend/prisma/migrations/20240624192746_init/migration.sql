-- CreateEnum
CREATE TYPE "Status" AS ENUM ('verfuegbar', 'abgeholt', 'verloren');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Jacket" (
    "id" SERIAL NOT NULL,
    "jacketNumber" INTEGER NOT NULL,
    "qrString" TEXT NOT NULL,
    "imagePath" TEXT NOT NULL,
    "status" "Status" NOT NULL DEFAULT 'verfuegbar',

    CONSTRAINT "Jacket_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Jacket_jacketNumber_key" ON "Jacket"("jacketNumber");

-- CreateIndex
CREATE UNIQUE INDEX "Jacket_qrString_key" ON "Jacket"("qrString");
