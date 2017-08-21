/* ============================================================
 * Bootstrap: rowlink.js v3.1.3
 * http://jasny.github.io/bootstrap/javascript/#rowlink
 * ============================================================
 * Copyright 2012-2014 Arnold Daniels
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */

+ function ($) {
    "use strict";

    var Rowlink = function (element, options) {
        this.$element = $(element)
        this.options = $.extend({}, Rowlink.DEFAULTS, options)
        var _this = this;

        this.$element.find('tr').each(function () {
            var target = $(this).find(_this.options.target).first();
            var $span = $('<span/>').addClass('view-text').html(target.html());

            target.parent().find('.view-text').remove();
            target.before($span);
            target.hide();
        });

        var clickFunc = $.proxy(this.click, this);

        this.$element.on('mousedown.bs.rowlink', 'td:not(.rowlink-skip)', function (e) {
            var sx = e.clientX;
            var sy = e.clientY;

            $(this).on('mouseup.bs.rowlink', clickFunc);

            $(this).on('mousemove.bs.rowlink', function (e) {
                if (Math.abs(e.clientY - sy) > 2 || Math.abs(e.clientX - sx) > 2) {
                    $(this).unbind('mouseup.bs.rowlink', clickFunc);
                    $(this).unbind('mousemove.bs.rowlink');
                }
            });
        });
    }

    Rowlink.DEFAULTS = {
        target: "a"
    }

    Rowlink.prototype.click = function (e) {
        var target = $(e.currentTarget).closest('tr').find(this.options.target)[0]
        if ($(e.target)[0] === target) return

        e.preventDefault();

        if (target.click) {
            if (e.ctrlKey && $(target).attr('href')) {
                window.open($(target).attr('href'), '_blank');
            } else {
                target.click()
            }
        } else if (document.createEvent) {
            var evt = document.createEvent("MouseEvents");
            evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            target.dispatchEvent(evt);
        }
    }


    // ROWLINK PLUGIN DEFINITION
    // ===========================

    var old = $.fn.rowlink

    $.fn.rowlink = function (options) {
        return this.each(function () {
            var $this = $(this)
            var data = $this.data('bs.rowlink')
            if (!data) $this.data('bs.rowlink', (data = new Rowlink(this, options)))
        })
    }

    $.fn.rowlink.Constructor = Rowlink


    // ROWLINK NO CONFLICT
    // ====================

    $.fn.rowlink.noConflict = function () {
        $.fn.rowlink = old
        return this
    }

}(window.jQuery);
