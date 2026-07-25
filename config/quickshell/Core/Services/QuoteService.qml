import QtQuick
pragma Singleton

QtObject {
    property int currentQuoteIndex: Math.floor(Math.random() * quotes.length)
    property var quotes: [{
        "text": "The only way to do great work is to love what you do.",
        "author": "Steve Jobs",
        "category": "Inspiration"
    }, {
        "text": "Waste no more time arguing about what a good man should be. Be one.",
        "author": "Marcus Aurelius",
        "category": "Philosophy"
    }, {
        "text": "We suffer more often in imagination than in reality.",
        "author": "Seneca",
        "category": "Philosophy"
    }, {
        "text": "The only true wisdom is in knowing you know nothing.",
        "author": "Socrates",
        "category": "Philosophy"
    }, {
        "text": "Life is what happens when you're busy making other plans.",
        "author": "John Lennon",
        "category": "Life"
    }, {
        "text": "The secret of change is to focus all of your energy, not on fighting the old, but on building the new.",
        "author": "Socrates",
        "category": "Wisdom"
    }, {
        "text": "Do not go where the path may lead, go instead where there is no path and leave a trail.",
        "author": "Ralph Waldo Emerson",
        "category": "Inspiration"
    }, {
        "text": "It is not that we have a short time to live, but that we waste a lot of it.",
        "author": "Seneca",
        "category": "Philosophy"
    }, {
        "text": "You have power over your mind - not outside events. Realize this, and you will find strength.",
        "author": "Marcus Aurelius",
        "category": "Philosophy"
    }, {
        "text": "Quiet minds cannot be perplexed or frightened but go on in fortune or misfortune at their own private pace, like a clock during a thunderstorm.",
        "author": "Robert Louis Stevenson",
        "category": "Mindfulness"
    }, {
        "text": "The present moment is filled with joy and happiness. If you are attentive, you will see it.",
        "author": "Thich Nhat Hanh",
        "category": "Mindfulness"
    }, {
        "text": "A journey of a thousand miles begins with a single step.",
        "author": "Lao Tzu",
        "category": "Wisdom"
    }, {
        "text": "Talk is cheap. Show me the code.",
        "author": "Linus Torvalds",
        "category": "Programming"
    }, {
        "text": "First, solve the problem. Then, write the code.",
        "author": "John Johnson",
        "category": "Programming"
    }, {
        "text": "Make it work, make it right, make it fast.",
        "author": "Kent Beck",
        "category": "Programming"
    }, {
        "text": "Programs must be written for people to read, and only incidentally for machines to execute.",
        "author": "Harold Abelson",
        "category": "Programming"
    }, {
        "text": "Code is like humor. When you have to explain it, it’s bad.",
        "author": "Cory House",
        "category": "Programming"
    }, {
        "text": "Simplicity is the soul of efficiency.",
        "author": "Austin Freeman",
        "category": "Programming"
    }, {
        "text": "There are only two hard things in Computer Science: cache invalidation and naming things.",
        "author": "Phil Karlton",
        "category": "Programming"
    }, {
        "text": "In order to understand recursion, one must first understand recursion.",
        "author": "Anonymous",
        "category": "Programming"
    }, {
        "text": "It's not a bug – it's an undocumented feature.",
        "author": "Anonymous",
        "category": "Humor"
    }, {
        "text": "The best thing about a boolean is even if you are wrong, you are only off by a bit.",
        "author": "Anonymous",
        "category": "Humor"
    }, {
        "text": "Complexity is your enemy. Any fool can make something complicated.",
        "author": "Tony Hoare",
        "category": "Programming"
    }, {
        "text": "Before software can be reusable it first has to be usable.",
        "author": "Ralph Johnson",
        "category": "Programming"
    }, {
        "text": "Keep it simple, stupid.",
        "author": "Kelly Johnson",
        "category": "Principle"
    }, {
        "text": "If it isn't broken, don't fix it.",
        "author": "Bert Lance",
        "category": "Principle"
    }, {
        "text": "You aren't gonna need it.",
        "author": "Ron Jeffries",
        "category": "Principle"
    }, {
        "text": "Premature optimization is the root of all evil.",
        "author": "Donald Knuth",
        "category": "Programming"
    }, {
        "text": "Simple is better than complex.",
        "author": "Tim Peters",
        "category": "Principle"
    }, {
        "text": "The function of good software is to make the invisible visible.",
        "author": "Steve McConnell",
        "category": "Programming"
    }, {
        "text": "Good design is obvious. That's why it's so hard to have good design.",
        "author": "Jeffrey Zeldman",
        "category": "Design"
    }, {
        "text": "Simplicity is the ultimate sophistication.",
        "author": "Leonardo da Vinci",
        "category": "Principle"
    }, {
        "text": "Design is not just what it looks like and feels like. Design is how it works.",
        "author": "Steve Jobs",
        "category": "Design"
    }, {
        "text": "The goal is to make the user's life easier, not to show off how smart we are.",
        "author": "Douglas Adams",
        "category": "Design"
    }, {
        "text": "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.",
        "author": "Antoine de Saint-Exupéry",
        "category": "Principle"
    }]
    readonly property var currentQuote: quotes[currentQuoteIndex]
}
