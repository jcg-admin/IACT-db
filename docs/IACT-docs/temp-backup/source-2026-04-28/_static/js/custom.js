/**
 * IACT - Custom JavaScript para Sphinx + Furo
 */

(function() {
    'use strict';

    // Esperar a que el DOM esté completamente cargado
    document.addEventListener('DOMContentLoaded', function() {
        
        // 1. Mejorar enlaces externos
        addExternalLinkIcons();
        
        // 2. Smooth scroll para enlaces internos
        enableSmoothScroll();
        
        // 3. Mejorar accesibilidad de tablas
        enhanceTableAccessibility();
        
        // 4. Agregar comportamiento a botones de copiado
        enhanceCopyButtons();
        
        // 5. Agregar tooltips a abreviaciones
        addTooltipsToAbbreviations();
    });

    /**
     * Agregar iconos a enlaces externos
     */
    function addExternalLinkIcons() {
        const links = document.querySelectorAll('.content a[href^="http"]');
        links.forEach(function(link) {
            // No agregar a imágenes
            if (link.querySelector('img')) return;
            
            // Verificar si es enlace externo
            if (!link.href.includes(window.location.hostname)) {
                link.setAttribute('target', '_blank');
                link.setAttribute('rel', 'noopener noreferrer');
                link.setAttribute('title', 'Abre en nueva pestaña');
            }
        });
    }

    /**
     * Habilitar smooth scroll para enlaces internos
     */
    function enableSmoothScroll() {
        const links = document.querySelectorAll('a[href^="#"]');
        links.forEach(function(link) {
            link.addEventListener('click', function(e) {
                const targetId = this.getAttribute('href');
                if (targetId === '#') return;
                
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    e.preventDefault();
                    targetElement.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                    // Actualizar URL sin saltar
                    history.pushState(null, null, targetId);
                }
            });
        });
    }

    /**
     * Mejorar accesibilidad de tablas
     */
    function enhanceTableAccessibility() {
        const tables = document.querySelectorAll('table.docutils');
        tables.forEach(function(table) {
            // Agregar role si no existe
            if (!table.getAttribute('role')) {
                table.setAttribute('role', 'table');
            }
            
            // Envolver tabla en contenedor responsive
            if (!table.parentElement.classList.contains('table-wrapper')) {
                const wrapper = document.createElement('div');
                wrapper.classList.add('table-wrapper');
                wrapper.style.overflowX = 'auto';
                table.parentNode.insertBefore(wrapper, table);
                wrapper.appendChild(table);
            }
        });
    }

    /**
     * Mejorar botones de copiado
     */
    function enhanceCopyButtons() {
        // Observar cuando se agregan nuevos botones de copiar
        const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                mutation.addedNodes.forEach(function(node) {
                    if (node.classList && node.classList.contains('copybtn')) {
                        addCopyFeedback(node);
                    }
                });
            });
        });

        // Observar el documento
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

        // Aplicar a botones existentes
        document.querySelectorAll('.copybtn').forEach(addCopyFeedback);
    }

    /**
     * Agregar feedback visual al copiar
     */
    function addCopyFeedback(button) {
        button.addEventListener('click', function() {
            const originalTitle = this.getAttribute('title') || 'Copiar';
            this.setAttribute('title', 'Copiado!');
            this.style.backgroundColor = '#27ae60';
            
            setTimeout(() => {
                this.setAttribute('title', originalTitle);
                this.style.backgroundColor = '';
            }, 2000);
        });
    }

    /**
     * Agregar tooltips a abreviaciones
     */
    function addTooltipsToAbbreviations() {
        const abbrs = document.querySelectorAll('abbr[title]');
        abbrs.forEach(function(abbr) {
            abbr.style.cursor = 'help';
            abbr.style.borderBottom = '1px dotted #199cd7';
        });
    }

    /**
     * Utilidad: Debounce para optimizar eventos
     */
    function debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    /**
     * Detección de scroll para efectos adicionales (opcional)
     */
    let lastScrollTop = 0;
    window.addEventListener('scroll', debounce(function() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        // Aquí puedes agregar efectos basados en scroll
        // Ejemplo: mostrar/ocultar botón "volver arriba"
        
        lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
    }, 100));

    /**
     * Mejorar animaciones de Cards al hacer scroll
     */
    function animateCardsOnScroll() {
        const cards = document.querySelectorAll('.sd-card');
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, {
            threshold: 0.1
        });
        
        cards.forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            observer.observe(card);
        });
    }

    /**
     * Sincronizar tema oscuro con preferencias del sistema
     */
    function syncThemeWithSystem() {
        // Furo ya maneja el tema, pero podemos agregar efectos personalizados
        const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
        
        function handleThemeChange(e) {
            // Agregar clase personalizada si se necesita
            if (e.matches) {
                document.body.classList.add('iact-dark-mode');
            } else {
                document.body.classList.remove('iact-dark-mode');
            }
        }
        
        // Aplicar al cargar
        handleThemeChange(mediaQuery);
        
        // Escuchar cambios
        mediaQuery.addEventListener('change', handleThemeChange);
    }

    /**
     * Agregar efecto de resaltado a elementos referenciados
     */
    function highlightReferencedElements() {
        // Si la URL tiene un hash (ej: #seccion-id)
        if (window.location.hash) {
            const targetElement = document.querySelector(window.location.hash);
            if (targetElement) {
                // Agregar clase temporal de highlight
                targetElement.classList.add('iact-highlighted');
                
                // Remover después de 2 segundos
                setTimeout(() => {
                    targetElement.classList.remove('iact-highlighted');
                }, 2000);
            }
        }
    }

    /**
     * Mejorar interacción con tabs de sphinx-tabs
     */
    function enhanceTabInteraction() {
        const tabs = document.querySelectorAll('.sphinx-tabs-tab');
        
        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                // Agregar efecto de ripple
                const ripple = document.createElement('span');
                ripple.classList.add('ripple-effect');
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });
    }

    /**
     * Mejorar visualización de admonitions colapsables
     */
    function enhanceAdmonitions() {
        const admonitions = document.querySelectorAll('.admonition');
        
        admonitions.forEach(admonition => {
            // Agregar animación al hacer hover
            admonition.addEventListener('mouseenter', function() {
                this.style.borderLeftWidth = '6px';
            });
            
            admonition.addEventListener('mouseleave', function() {
                this.style.borderLeftWidth = '4px';
            });
        });
    }

    /**
     * Progress bar de lectura en la parte superior
     */
    function addReadingProgressBar() {
        // Crear barra de progreso
        const progressBar = document.createElement('div');
        progressBar.id = 'reading-progress-bar';
        progressBar.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            height: 3px;
            background: linear-gradient(90deg, #199cd7, #0276ba);
            width: 0%;
            z-index: 9999;
            transition: width 0.2s ease;
        `;
        document.body.appendChild(progressBar);
        
        // Actualizar progreso al hacer scroll
        window.addEventListener('scroll', debounce(function() {
            const windowHeight = window.innerHeight;
            const documentHeight = document.documentElement.scrollHeight - windowHeight;
            const scrolled = window.scrollY;
            const progress = (scrolled / documentHeight) * 100;
            
            progressBar.style.width = progress + '%';
        }, 50));
    }

    /**
     * Mejorar código con números de línea
     */
    function enhanceCodeBlocks() {
        const codeBlocks = document.querySelectorAll('div.highlight pre');
        
        codeBlocks.forEach(block => {
            // Agregar efecto hover en bloques de código
            block.addEventListener('mouseenter', function() {
                this.style.borderLeftWidth = '5px';
            });
            
            block.addEventListener('mouseleave', function() {
                this.style.borderLeftWidth = '3px';
            });
        });
    }

    /**
     * Botón "Volver Arriba" flotante
     */
    function addBackToTopButton() {
        const button = document.createElement('button');
        button.id = 'back-to-top';
        button.innerHTML = '↑';
        button.setAttribute('aria-label', 'Volver arriba');
        button.style.cssText = `
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #199cd7;
            color: white;
            border: none;
            font-size: 24px;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        `;
        
        document.body.appendChild(button);
        
        // Mostrar/ocultar botón según scroll
        window.addEventListener('scroll', debounce(function() {
            if (window.pageYOffset > 300) {
                button.style.opacity = '1';
                button.style.visibility = 'visible';
            } else {
                button.style.opacity = '0';
                button.style.visibility = 'hidden';
            }
        }, 100));
        
        // Funcionalidad del botón
        button.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
        
        // Efecto hover
        button.addEventListener('mouseenter', function() {
            this.style.backgroundColor = '#0276ba';
            this.style.transform = 'scale(1.1)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.backgroundColor = '#199cd7';
            this.style.transform = 'scale(1)';
        });
    }

    /**
     * Inicializar todas las funcionalidades adicionales
     */
    function initIACTEnhancements() {
        animateCardsOnScroll();
        syncThemeWithSystem();
        highlightReferencedElements();
        enhanceTabInteraction();
        enhanceAdmonitions();
        addReadingProgressBar();
        enhanceCodeBlocks();
        addBackToTopButton();
    }

    // Ejecutar mejoras IACT
    initIACTEnhancements();

})();