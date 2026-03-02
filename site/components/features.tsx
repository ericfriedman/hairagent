const features = [
  {
    title: "All-Natural Ingredients",
    description: "Honey, coconut oil, aloe vera — stuff from your kitchen.",
    color: "bg-ha-pink/30",
  },
  {
    title: "Personalized to You",
    description: "Not generic advice. Matched to YOUR hair type and goals.",
    color: "bg-ha-blue/30",
  },
  {
    title: "No Salon Needed",
    description: "Professional-quality care, DIY style.",
    color: "bg-ha-coral/30",
  },
  {
    title: "Fun for Everyone",
    description: "Whether you're 11 or 41, great hair has no age limit.",
    color: "bg-ha-yellow/30",
  },
];

export function Features() {
  return (
    <section className="py-24 px-6 bg-gray-50">
      <div className="mx-auto max-w-7xl">
        <h2 className="text-4xl md:text-5xl font-bold text-center text-black mb-16">
          What Makes It Different
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {features.map((feature) => (
            <div
              key={feature.title}
              className={`p-8 rounded-3xl ${feature.color}`}
            >
              <h3 className="text-2xl font-bold text-black mb-3">
                {feature.title}
              </h3>
              <p className="text-lg text-black/60">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
