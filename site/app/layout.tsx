import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Hair Agent - Your Personal Hair Care Advisor",
  description:
    "Take a quick hair quiz and get personalized DIY hair care recipes using ingredients you already have at home.",
  openGraph: {
    title: "Hair Agent - Meet Your New Hair BFF",
    description:
      "Personalized hair care tips from your kitchen. Take the quiz, get custom recipes.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`${inter.className} antialiased`}>
        {children}
      </body>
    </html>
  );
}
