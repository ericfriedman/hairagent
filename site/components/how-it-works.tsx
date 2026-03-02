import { Sparkle } from "./sparkle";

const steps = [
  {
    number: "1",
    title: "Take a Quick Quiz",
    description: "Tell us about your hair color, texture, and goals.",
    bgColor: "bg-ha-pink",
    sparkleColor: "#e8899a",
  },
  {
    number: "2",
    title: "Get Personalized Tips",
    description: "We match you with DIY solutions tailored to your hair.",
    bgColor: "bg-ha-blue",
    sparkleColor: "#89b8d4",
  },
  {
    number: "3",
    title: "Make It at Home",
    description: "Every recipe uses ingredients you already have in your kitchen.",
    bgColor: "bg-ha-yellow",
    sparkleColor: "#d4c46e",
  },
];

export function HowItWorks() {
  return (
    <section className="py-24 px-6 bg-gray-50/50">
      <div className="mx-auto max-w-7xl">
        <h2 className="text-4xl md:text-5xl font-bold text-center text-black mb-16">
          How It Works
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {steps.map((step) => (
            <div
              key={step.number}
              className="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden"
            >
              {/* Colored top panel with sparkle - like the app cards */}
              <div
                className={`${step.bgColor} h-40 flex items-center justify-center relative`}
              >
                <Sparkle className="w-12 h-12" color={step.sparkleColor} />
              </div>
              {/* Text content below */}
              <div className="p-6">
                <h3 className="text-xl font-bold text-black mb-2">
                  {step.title}
                </h3>
                <p className="text-base text-black/50">{step.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
