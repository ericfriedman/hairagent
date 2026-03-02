const steps = [
  {
    number: "1",
    title: "Take a Quick Quiz",
    description: "Tell us about your hair color, texture, and goals.",
    color: "bg-ha-pink",
  },
  {
    number: "2",
    title: "Get Personalized Tips",
    description: "We match you with DIY solutions tailored to your hair.",
    color: "bg-ha-blue",
  },
  {
    number: "3",
    title: "Make It at Home",
    description: "Every recipe uses ingredients you already have in your kitchen.",
    color: "bg-ha-yellow",
  },
];

export function HowItWorks() {
  return (
    <section className="py-24 px-6 bg-white">
      <div className="mx-auto max-w-7xl">
        <h2 className="text-4xl md:text-5xl font-bold text-center text-black mb-16">
          How It Works
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {steps.map((step) => (
            <div
              key={step.number}
              className="text-center p-8 rounded-3xl bg-gray-50"
            >
              <div
                className={`inline-flex items-center justify-center w-14 h-14 rounded-full ${step.color} text-black text-2xl font-bold mb-6`}
              >
                {step.number}
              </div>
              <h3 className="text-2xl font-bold text-black mb-3">
                {step.title}
              </h3>
              <p className="text-lg text-black/60">{step.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
