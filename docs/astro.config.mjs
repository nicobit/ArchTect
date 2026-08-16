// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://archstudio.io',
	integrations: [
		starlight({
			title: 'ArchTect Docs',
			description: 'Documentation for ArchTect — the visual, AI-assisted Structurizr DSL editor',
			logo: {
				src: './src/assets/archtect_logo_horizontal.svg',
				replacesTitle: true,
			},
			favicon: '/archtect_favicon.svg',
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/nicobit/Archtect' }],
			customCss: ['./src/styles/custom.css'],
			components: {
				Hero: './src/components/Hero.astro',
				Sidebar: './src/components/Sidebar.astro',
				PageFrame: './src/components/PageFrame.astro',
				Head: './src/components/Head.astro',
			},
			expressiveCode: {
				shiki: {
					// Structurizr DSL has no dedicated grammar; HCL's `block "type" "name" { key = value }`
					// shape is the closest existing match for readable highlighting.
					langAlias: { dsl: 'hcl' },
				},
			},
			sidebar: [
				{
					label: 'Overview',
					items: [
						{ label: 'Overview', slug: 'overview' },
						{ label: 'Why ArchTect', slug: 'why-archtect' },
					],
				},
				{
					label: 'Getting Started',
					items: [{ autogenerate: { directory: 'getting-started' } }],
				},
				{
					label: 'Portal Guide',
					items: [{ autogenerate: { directory: 'portal-guide' } }],
				},
				{
					label: 'Modeling',
					items: [{ autogenerate: { directory: 'modeling' } }],
				},
				{
					label: 'Editing',
					items: [{ autogenerate: { directory: 'editing' } }],
				},
				{
					label: 'Export & Documentation',
					items: [{ autogenerate: { directory: 'export' } }],
				},
				{
					label: 'VS Code Extension',
					items: [{ autogenerate: { directory: 'vscode-extension' } }],
				},
				{
					label: 'Plugins',
					items: [{ autogenerate: { directory: 'plugins' } }],
				},
				{
					label: 'Troubleshooting',
					items: [{ autogenerate: { directory: 'troubleshooting' } }],
				},
				{
					label: 'Reference',
					items: [{ autogenerate: { directory: 'reference' } }],
				},
				{
					label: 'Contributing',
					items: [{ autogenerate: { directory: 'contributing' } }],
				},
				{
					label: 'Changelog',
					items: [{ label: 'Changelog', slug: 'changelog' }],
				},
			],
		}),
	],
});
