defmodule Jutilis.Launchpad.Templates do
  @moduledoc """
  Default templates for the SaaS Launchpad Roadmap.
  Contains phase definitions, categories, and recommended tools.
  """

  @phases [
    %{
      id: "planning",
      name: "Planning",
      description: "Lay the foundation for your SaaS business",
      icon: "hero-clipboard-document-list",
      color: "primary"
    },
    %{
      id: "building",
      name: "Building",
      description: "Develop and launch your product",
      icon: "hero-wrench-screwdriver",
      color: "secondary"
    },
    %{
      id: "maintaining",
      name: "Maintaining",
      description: "Scale and grow your business",
      icon: "hero-chart-bar",
      color: "success"
    }
  ]

  @categories [
    # PLANNING PHASE (1-4)
    %{
      slug: "legal",
      name: "Legal Structure",
      phase: "planning",
      display_order: 1,
      icon: "hero-scale",
      description: "Business formation and legal protection"
    },
    %{
      slug: "banking",
      name: "Banking",
      phase: "planning",
      display_order: 2,
      icon: "hero-banknotes",
      description: "Business banking and financial setup"
    },
    %{
      slug: "domains",
      name: "Domains",
      phase: "planning",
      display_order: 3,
      icon: "hero-globe-alt",
      description: "Domain registration and DNS management"
    },
    %{
      slug: "learning",
      name: "Learning",
      phase: "planning",
      display_order: 4,
      icon: "hero-academic-cap",
      description: "Educational resources for building SaaS"
    },
    # BUILDING PHASE (5-12)
    %{
      slug: "planning-design",
      name: "Planning & Design",
      phase: "building",
      display_order: 5,
      icon: "hero-squares-2x2",
      description: "Project management and design tools"
    },
    %{
      slug: "code-repos",
      name: "Code Repos",
      phase: "building",
      display_order: 6,
      icon: "hero-code-bracket",
      description: "Version control and code hosting"
    },
    %{
      slug: "workspace",
      name: "Workspace & Dev Environment",
      phase: "building",
      display_order: 7,
      icon: "hero-computer-desktop",
      description: "Development environment and collaboration tools"
    },
    %{
      slug: "ai-tools",
      name: "AI Tools",
      phase: "building",
      display_order: 8,
      icon: "hero-sparkles",
      description: "AI assistants for coding and productivity"
    },
    %{
      slug: "hosting",
      name: "Hosting",
      phase: "building",
      display_order: 9,
      icon: "hero-server",
      description: "Application hosting and deployment"
    },
    %{
      slug: "ci-cd",
      name: "CI/CD",
      phase: "building",
      display_order: 10,
      icon: "hero-arrow-path",
      description: "Continuous integration and deployment"
    },
    %{
      slug: "email",
      name: "Email (Transactional)",
      phase: "building",
      display_order: 11,
      icon: "hero-envelope",
      description: "Transactional email services"
    },
    %{
      slug: "error-monitoring",
      name: "Error Monitoring",
      phase: "building",
      display_order: 12,
      icon: "hero-exclamation-triangle",
      description: "Error tracking and application monitoring"
    },
    # MAINTAINING PHASE (13-17)
    %{
      slug: "customer-support",
      name: "Customer Support",
      phase: "maintaining",
      display_order: 13,
      icon: "hero-chat-bubble-left-right",
      description: "Customer support and help desk tools"
    },
    %{
      slug: "analytics",
      name: "Analytics",
      phase: "maintaining",
      display_order: 14,
      icon: "hero-chart-pie",
      description: "Analytics and product insights"
    },
    %{
      slug: "marketing-ads",
      name: "Marketing & Paid Ads",
      phase: "maintaining",
      display_order: 15,
      icon: "hero-megaphone",
      description: "Paid advertising platforms"
    },
    %{
      slug: "social-media",
      name: "Social Media & Community",
      phase: "maintaining",
      display_order: 16,
      icon: "hero-share",
      description: "Social media and community building"
    },
    %{
      slug: "crm-email-marketing",
      name: "CRM & Email Marketing",
      phase: "maintaining",
      display_order: 17,
      icon: "hero-user-group",
      description: "Customer relationship and email marketing"
    }
  ]

  @tools [
    # === PLANNING PHASE ===

    # 1. Legal Structure
    %{
      category: "legal",
      name: "Wyoming LLC + Registered Agent",
      slug: "wyoming-llc",
      url: "https://www.wyomingagents.com",
      description: "Best for solo founders, asset protection with privacy benefits",
      factoid: "Wyoming offers strong privacy laws and no state income tax",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "legal",
      name: "Stripe Atlas",
      slug: "stripe-atlas",
      url: "https://stripe.com/atlas",
      description: "Delaware C-Corp formation with banking and legal docs",
      factoid: "One-stop shop for incorporating, banking, and getting started",
      pricing_info: "$500 one-time",
      display_order: 2
    },
    %{
      category: "legal",
      name: "Clerky",
      slug: "clerky",
      url: "https://clerky.com",
      description: "YC-recommended startup legal documents",
      factoid: "Automates legal paperwork used by thousands of startups",
      display_order: 3
    },

    # 2. Banking
    %{
      category: "banking",
      name: "Found",
      slug: "found",
      url: "https://found.com",
      description: "Banking built for self-employed and small business",
      factoid: "Automatic tax savings, invoicing, and bookkeeping in one app",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "banking",
      name: "Mercury",
      slug: "mercury",
      url: "https://mercury.com",
      description: "Startup-focused banking with great UX",
      factoid: "Free business banking designed for startups",
      pricing_info: "Free",
      display_order: 2
    },
    %{
      category: "banking",
      name: "Brex",
      slug: "brex",
      url: "https://brex.com",
      description: "Corporate cards and spend management",
      factoid: "No personal guarantee required for credit",
      display_order: 3
    },

    # 3. Domains
    %{
      category: "domains",
      name: "Squarespace Domains",
      slug: "squarespace-domains",
      url: "https://domains.squarespace.com",
      description: "Simple domain management with good DNS",
      factoid: "Clean interface, includes privacy protection",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "domains",
      name: "Cloudflare",
      slug: "cloudflare",
      url: "https://cloudflare.com",
      description: "DNS, CDN, and at-cost domain registration",
      factoid: "At-cost domain registration with free CDN and DDoS protection",
      pricing_info: "Free tier",
      display_order: 2
    },
    %{
      category: "domains",
      name: "Namecheap",
      slug: "namecheap",
      url: "https://namecheap.com",
      description: "Affordable domain registration",
      factoid: "Great prices and free WhoisGuard privacy protection",
      display_order: 3
    },

    # 4. Learning
    %{
      category: "learning",
      name: "Elixir Mentor",
      slug: "elixir-mentor",
      url: "https://elixirmentor.com",
      description: "1-on-1 Elixir/Phoenix mentorship",
      factoid: "Get personalized guidance from experienced Elixir developers",
      display_order: 1
    },
    %{
      category: "learning",
      name: "DockYard Academy",
      slug: "dockyard-academy",
      url: "https://academy.dockyard.com",
      description: "Free comprehensive Elixir curriculum",
      factoid: "Open-source curriculum covering Elixir fundamentals to Phoenix",
      pricing_info: "Free",
      display_order: 2
    },
    %{
      category: "learning",
      name: "Pragmatic Studio",
      slug: "pragmatic-studio",
      url: "https://pragmaticstudio.com",
      description: "In-depth Phoenix and LiveView courses",
      factoid: "High-quality video courses from experienced instructors",
      display_order: 3
    },

    # === BUILDING PHASE ===

    # 5. Planning & Design
    %{
      category: "planning-design",
      name: "Huly",
      slug: "huly",
      url: "https://huly.io",
      description: "Open source project management platform",
      factoid: "All-in-one workspace with issues, docs, and chat",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "planning-design",
      name: "Figma",
      slug: "figma",
      url: "https://figma.com",
      description: "Collaborative design tool",
      factoid: "Industry standard for UI/UX design and prototyping",
      is_featured: true,
      display_order: 2
    },
    %{
      category: "planning-design",
      name: "Jira",
      slug: "jira",
      url: "https://atlassian.com/software/jira",
      description: "Enterprise-grade issue tracking",
      factoid: "Powerful for agile teams, extensive integrations",
      display_order: 3
    },
    %{
      category: "planning-design",
      name: "Linear",
      slug: "linear",
      url: "https://linear.app",
      description: "Lightning fast, beautiful project management",
      factoid: "Built for speed, loved by modern dev teams",
      display_order: 4
    },

    # 6. Code Repos
    %{
      category: "code-repos",
      name: "GitHub",
      slug: "github",
      url: "https://github.com",
      description: "Industry standard code hosting",
      factoid: "Free private repos, Codespaces, and Actions included",
      pricing_info: "Free tier",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "code-repos",
      name: "GitLab",
      slug: "gitlab",
      url: "https://gitlab.com",
      description: "All-in-one DevOps platform with built-in CI",
      factoid: "Complete DevOps lifecycle in one application",
      is_featured: true,
      display_order: 2
    },

    # 7. Workspace & Dev Environment
    %{
      category: "workspace",
      name: "GitHub Codespaces",
      slug: "github-codespaces",
      url: "https://github.com/features/codespaces",
      description: "Cloud development environments",
      factoid: "Full VS Code in the browser, pre-configured environments",
      pricing_info: "60 hrs/month free",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "workspace",
      name: "Google Workspace",
      slug: "google-workspace",
      url: "https://workspace.google.com",
      description: "Team collaboration suite",
      factoid: "Email, calendar, docs, and storage for teams",
      is_featured: true,
      display_order: 2
    },
    %{
      category: "workspace",
      name: "VS Code",
      slug: "vs-code",
      url: "https://code.visualstudio.com",
      description: "Free, extensible code editor",
      factoid: "Most popular editor with thousands of extensions",
      pricing_info: "Free",
      display_order: 3
    },

    # 8. AI Tools
    %{
      category: "ai-tools",
      name: "Claude Code",
      slug: "claude-code",
      url: "https://claude.ai/code",
      description: "Anthropic's CLI coding assistant",
      factoid: "Agentic coding assistant that works in your terminal",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "ai-tools",
      name: "GitHub Copilot",
      slug: "github-copilot",
      url: "https://github.com/features/copilot",
      description: "AI pair programmer in your IDE",
      factoid: "Real-time code suggestions and completions",
      pricing_info: "$10/mo",
      display_order: 2
    },
    %{
      category: "ai-tools",
      name: "Cursor",
      slug: "cursor",
      url: "https://cursor.sh",
      description: "AI-first code editor",
      factoid: "VS Code fork with deep AI integration",
      display_order: 3
    },
    %{
      category: "ai-tools",
      name: "Gemini",
      slug: "gemini",
      url: "https://gemini.google.com",
      description: "Google's AI for code and research",
      factoid: "Multimodal AI with strong reasoning capabilities",
      display_order: 4
    },
    %{
      category: "ai-tools",
      name: "ChatGPT",
      slug: "chatgpt",
      url: "https://chat.openai.com",
      description: "OpenAI's versatile assistant",
      factoid: "General purpose AI with code generation capabilities",
      display_order: 5
    },
    %{
      category: "ai-tools",
      name: "v0 by Vercel",
      slug: "v0",
      url: "https://v0.dev",
      description: "AI UI component generation",
      factoid: "Generate React/Tailwind components from prompts",
      display_order: 6
    },

    # 9. Hosting
    %{
      category: "hosting",
      name: "Fly.io",
      slug: "fly-io",
      url: "https://fly.io",
      description: "Deploy apps close to users globally",
      factoid: "Perfect for Phoenix apps with built-in clustering support",
      pricing_info: "Free tier",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "hosting",
      name: "DigitalOcean",
      slug: "digitalocean",
      url: "https://digitalocean.com",
      description: "Simple cloud infrastructure",
      factoid: "Developer-friendly with predictable pricing",
      is_featured: true,
      display_order: 2
    },
    %{
      category: "hosting",
      name: "Google Cloud Platform",
      slug: "gcp",
      url: "https://cloud.google.com",
      description: "Enterprise scale when needed",
      factoid: "Comprehensive cloud with strong data and AI services",
      is_featured: true,
      display_order: 3
    },
    %{
      category: "hosting",
      name: "Render",
      slug: "render",
      url: "https://render.com",
      description: "Heroku alternative with free tier",
      factoid: "Simple deploys with automatic SSL and scaling",
      pricing_info: "Free tier",
      display_order: 4
    },
    %{
      category: "hosting",
      name: "Railway",
      slug: "railway",
      url: "https://railway.app",
      description: "Deploy from GitHub instantly",
      factoid: "Great developer experience with automatic deploys",
      display_order: 5
    },

    # 10. CI/CD
    %{
      category: "ci-cd",
      name: "GitHub Actions",
      slug: "github-actions",
      url: "https://github.com/features/actions",
      description: "CI/CD built into GitHub",
      factoid: "2000 free minutes/month for private repos",
      pricing_info: "Free tier",
      display_order: 1
    },
    %{
      category: "ci-cd",
      name: "GitLab CI",
      slug: "gitlab-ci",
      url: "https://docs.gitlab.com/ee/ci/",
      description: "Integrated CI/CD with GitLab repos",
      factoid: "Tightly integrated with GitLab's DevOps platform",
      display_order: 2
    },

    # 11. Email (Transactional)
    %{
      category: "email",
      name: "Resend",
      slug: "resend",
      url: "https://resend.com",
      description: "Modern email API for developers",
      factoid: "Built by developers, beautiful email templates with React",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "email",
      name: "ClickSend",
      slug: "clicksend",
      url: "https://clicksend.com",
      description: "SMS + Email combined",
      factoid: "Multi-channel messaging including SMS, email, and voice",
      display_order: 2
    },
    %{
      category: "email",
      name: "Postmark",
      slug: "postmark",
      url: "https://postmarkapp.com",
      description: "Reliable transactional email",
      factoid: "Industry-leading deliverability and detailed analytics",
      display_order: 3
    },

    # 12. Error Monitoring
    %{
      category: "error-monitoring",
      name: "Sentry",
      slug: "sentry",
      url: "https://sentry.io",
      description: "Industry standard error tracking",
      factoid: "Real-time error tracking with detailed stack traces",
      is_featured: true,
      display_order: 1
    },
    %{
      category: "error-monitoring",
      name: "Honeybadger",
      slug: "honeybadger",
      url: "https://honeybadger.io",
      description: "Exception monitoring for Elixir",
      factoid: "First-class Elixir support with uptime monitoring",
      display_order: 2
    },
    %{
      category: "error-monitoring",
      name: "AppSignal",
      slug: "appsignal",
      url: "https://appsignal.com",
      description: "APM + error tracking for Elixir",
      factoid: "Performance monitoring and error tracking in one",
      display_order: 3
    },

    # === MAINTAINING PHASE ===

    # 13. Customer Support
    %{
      category: "customer-support",
      name: "Zendesk",
      slug: "zendesk",
      url: "https://zendesk.com",
      description: "Full-featured support platform",
      factoid: "Comprehensive ticketing with knowledge base and chat",
      display_order: 1
    },
    %{
      category: "customer-support",
      name: "Freshdesk",
      slug: "freshdesk",
      url: "https://freshdesk.com",
      description: "Affordable support alternative",
      factoid: "Feature-rich with generous free tier",
      display_order: 2
    },
    %{
      category: "customer-support",
      name: "Crisp",
      slug: "crisp",
      url: "https://crisp.chat",
      description: "All-in-one messaging platform",
      factoid: "Live chat, chatbot, and knowledge base combined",
      pricing_info: "Free tier",
      display_order: 3
    },
    %{
      category: "customer-support",
      name: "Intercom",
      slug: "intercom",
      url: "https://intercom.com",
      description: "Premium customer messaging",
      factoid: "Advanced features for engagement and support",
      display_order: 4
    },

    # 14. Analytics
    %{
      category: "analytics",
      name: "Plausible",
      slug: "plausible",
      url: "https://plausible.io",
      description: "Privacy-friendly analytics",
      factoid: "GDPR compliant, no cookie banner needed",
      pricing_info: "$9/mo",
      display_order: 1
    },
    %{
      category: "analytics",
      name: "PostHog",
      slug: "posthog",
      url: "https://posthog.com",
      description: "Product analytics + feature flags",
      factoid: "Open source alternative with session recording",
      pricing_info: "Free tier",
      display_order: 2
    },
    %{
      category: "analytics",
      name: "Google Analytics",
      slug: "google-analytics",
      url: "https://analytics.google.com",
      description: "Free, comprehensive analytics",
      factoid: "Powerful but requires cookie consent",
      pricing_info: "Free",
      display_order: 3
    },

    # 15. Marketing & Paid Ads
    %{
      category: "marketing-ads",
      name: "Google Ads",
      slug: "google-ads",
      url: "https://ads.google.com",
      description: "Search and display advertising",
      factoid: "Reach users actively searching for solutions",
      display_order: 1
    },
    %{
      category: "marketing-ads",
      name: "Facebook Ads / Meta",
      slug: "facebook-ads",
      url: "https://business.facebook.com",
      description: "Social advertising platform",
      factoid: "Detailed targeting with massive reach",
      display_order: 2
    },
    %{
      category: "marketing-ads",
      name: "Instagram Ads",
      slug: "instagram-ads",
      url: "https://business.instagram.com",
      description: "Visual advertising via Meta",
      factoid: "Great for visual products and younger demographics",
      display_order: 3
    },
    %{
      category: "marketing-ads",
      name: "Snapchat Ads",
      slug: "snapchat-ads",
      url: "https://forbusiness.snapchat.com",
      description: "Reach younger demographics",
      factoid: "Strong with Gen Z and millennial audiences",
      display_order: 4
    },
    %{
      category: "marketing-ads",
      name: "YouTube Ads",
      slug: "youtube-ads",
      url: "https://ads.google.com/home/campaigns/video-ads/",
      description: "Video advertising",
      factoid: "Second largest search engine, great for demos",
      display_order: 5
    },
    %{
      category: "marketing-ads",
      name: "TikTok Ads",
      slug: "tiktok-ads",
      url: "https://ads.tiktok.com",
      description: "Short-form video advertising",
      factoid: "Viral potential with authentic content",
      display_order: 6
    },

    # 16. Social Media & Community
    %{
      category: "social-media",
      name: "Discord",
      slug: "discord",
      url: "https://discord.com",
      description: "Community building and support",
      factoid: "Real-time community engagement with voice and text",
      display_order: 1
    },
    %{
      category: "social-media",
      name: "Twitter / X",
      slug: "twitter",
      url: "https://twitter.com",
      description: "Tech community engagement",
      factoid: "Essential for developer relations and announcements",
      display_order: 2
    },
    %{
      category: "social-media",
      name: "LinkedIn",
      slug: "linkedin",
      url: "https://linkedin.com",
      description: "B2B networking and content",
      factoid: "Professional audience, great for B2B SaaS",
      display_order: 3
    },
    %{
      category: "social-media",
      name: "Buffer",
      slug: "buffer",
      url: "https://buffer.com",
      description: "Social media scheduling",
      factoid: "Simple scheduling across all platforms",
      pricing_info: "Free tier",
      display_order: 4
    },
    %{
      category: "social-media",
      name: "Hootsuite",
      slug: "hootsuite",
      url: "https://hootsuite.com",
      description: "Enterprise social management",
      factoid: "Comprehensive social media management at scale",
      display_order: 5
    },

    # 17. CRM & Email Marketing
    %{
      category: "crm-email-marketing",
      name: "HubSpot",
      slug: "hubspot",
      url: "https://hubspot.com",
      description: "Free CRM with marketing tools",
      factoid: "Generous free tier with CRM, marketing, and sales",
      pricing_info: "Free tier",
      display_order: 1
    },
    %{
      category: "crm-email-marketing",
      name: "ConvertKit",
      slug: "convertkit",
      url: "https://convertkit.com",
      description: "Email marketing for creators",
      factoid: "Great for building an audience pre-launch",
      display_order: 2
    },
    %{
      category: "crm-email-marketing",
      name: "Mailchimp",
      slug: "mailchimp",
      url: "https://mailchimp.com",
      description: "All-in-one marketing platform",
      factoid: "Popular with small businesses, easy to start",
      pricing_info: "Free tier",
      display_order: 3
    }
  ]

  def phases, do: @phases
  def categories, do: @categories
  def tools, do: @tools

  def phase_info(phase_id) do
    Enum.find(@phases, fn p -> p.id == phase_id end)
  end

  def categories_for_phase(phase_id) do
    @categories
    |> Enum.filter(fn c -> c.phase == phase_id end)
    |> Enum.sort_by(& &1.display_order)
  end

  def tools_for_category(category_slug) do
    @tools
    |> Enum.filter(fn t -> t.category == category_slug end)
    |> Enum.sort_by(fn t -> {!t[:is_featured], t.display_order} end)
  end
end
